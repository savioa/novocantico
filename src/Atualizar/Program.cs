namespace NovoCantico;

using System.Diagnostics;
using System.Text;
using System.Xml;
using System.Xml.Linq;
using System.Xml.Schema;
using System.Xml.XPath;
using System.Xml.Xsl;

internal class Program
{
    private static void Main(string[] args)
    {
        Stopwatch sw = new();
        sw.Start();

        Directory.SetCurrentDirectory("..\\..\\xml");

        XmlSchemaSet schemas = new();
        foreach (string caminhoXsd in Directory.EnumerateFiles("xsd"))
        {
            schemas.Add("http://www.novocantico.com.br/schema/hino", caminhoXsd);
        }

        XmlNamespaceManager nsm = new(new NameTable());
        nsm.AddNamespace("xs", "http://www.w3.org/2001/XMLSchema");

        Dictionary<string, string> metricas = new();

        XDocument xdMetrica = XDocument.Load("xsd\\metrica.xsd");
        foreach (XElement itemMetrica in xdMetrica.XPathSelectElements("//xs:enumeration", nsm))
        {
            string idMetrica = itemMetrica.Attribute("value")!.Value;

            if (metricas.ContainsKey(idMetrica))
            {
                throw new Exception($"A métrica foi definida duas vezes: {idMetrica}");
            }

            string descricaoMetrica = itemMetrica.XPathSelectElement(".//xs:documentation", nsm)!.Value;

            if (idMetrica != descricaoMetrica.Replace('.', '_').Replace('[', '_').Replace(']', '_'))
            {
                throw new Exception($"O identificador e a descrição da métrica não são compatíveis: {idMetrica} {descricaoMetrica}");
            }

            metricas.Add(idMetrica, descricaoMetrica);
        }

        Dictionary<string, (string Descricao, string Referencia)> origens = new();

        XDocument xdOrigem = XDocument.Load("xsd\\origem.xsd");
        foreach (XElement itemOrigem in xdOrigem.XPathSelectElements("//xs:enumeration", nsm))
        {
            string idOrigem = itemOrigem.Attribute("value")!.Value;

            if (origens.ContainsKey(idOrigem))
            {
                throw new Exception($"A origem foi definida duas vezes: {idOrigem}");
            }

            string descricaoOrigem = itemOrigem.XPathSelectElement(".//xs:documentation", nsm)!.Value;
            string referenciaOrigem = itemOrigem.XPathSelectElement(".//xs:appinfo", nsm)!.Value;

            if (referenciaOrigem.Contains(','))
            {
                string[] partes = referenciaOrigem.Split(", ");

                if ($"{partes[1]} {partes[0]}" != descricaoOrigem)
                {
                    throw new Exception($"A descrição e a referência da origem não são compatíveis: {descricaoOrigem} {referenciaOrigem}");
                }
            }

            origens.Add(idOrigem, (descricaoOrigem, referenciaOrigem));
        }

        Dictionary<string, string> referencias = new();

        XDocument xdReferencia = XDocument.Load("xsd\\referencia_biblica.xsd");
        foreach (XElement itemReferencia in xdReferencia.XPathSelectElements("//xs:enumeration", nsm))
        {
            string idReferencia = itemReferencia.Attribute("value")!.Value;

            if (referencias.ContainsKey(idReferencia))
            {
                throw new Exception($"A referência foi definida duas vezes: {idReferencia}");
            }

            string descricaoReferencia = itemReferencia.XPathSelectElement(".//xs:documentation", nsm)!.Value;

            referencias.Add(idReferencia, descricaoReferencia);
        }

        List<Hino> hinario = new();

        Dictionary<string, Indice> indices = new()
        {
            { "assunto", new Indice("Assunto") },
            { "primeiro-verso", new Indice("Primeiro Verso") },
            { "coro", new Indice("Coro") },
            { "origem-letra", new Indice("Origem da Letra") },
            { "origem-musica", new Indice("Origem da Música") },
            { "referencia-biblica", new Indice("Referência Bíblica") },
            { "titulo-original", new Indice("Título Original") },
            { "primeiro-verso-original", new Indice("Primeiro Verso Original") },
            { "metrica", new Indice("Métrica") },
        };

        XslCompiledTransform transformer = new();
        transformer.Load("hino.xsl");

        foreach (string caminhoXml in Directory.EnumerateFiles(Directory.GetCurrentDirectory(), "*.xml"))
        {
            XDocument xdHino = XDocument.Load(caminhoXml);

            string erro = string.Empty;
            xdHino.Validate(schemas, (o, e) =>
            {
                erro = e.Message;
            });

            if (!string.IsNullOrEmpty(erro))
            {
                Console.WriteLine($"{Path.GetFileName(caminhoXml)} - {erro}");
                return;
            }

            Hino hino = new(xdHino);
            hinario.Add(hino);

            // Preenchimento de índices

            string idSecao = hino.Secao.Substring(0, 2);
            string secao = hino.Secao.Substring(3).Replace('_', ' ');
            string idAssunto = hino.Assunto.Substring(0, 5);
            string assunto = hino.Assunto.Substring(6).Replace('_', ' ');
            indices["assunto"].AdicionarOcorrencia(idSecao, secao, idAssunto, assunto, hino);

            string idPrimeiroVerso = ObterInicial(hino.PrimeiroVerso);
            indices["primeiro-verso"].AdicionarOcorrencia(idPrimeiroVerso.ToLower(), idPrimeiroVerso, RemoverTerminais(hino.PrimeiroVerso), string.Empty, hino);

            if (hino.Letra[0].Coros.Any())
            {
                string primeiroVersoCoro = hino.Letra[0].Coros[0].Versos[0].Texto;
                string idCoro = ObterInicial(primeiroVersoCoro);
                indices["coro"].AdicionarOcorrencia(idCoro.ToLower(), idCoro, RemoverTerminais(primeiroVersoCoro), string.Empty, hino);
            }

            foreach (Hino.Origem origem in hino.OrigemLetra)
            {
                string origemLetra = origens[origem.Identificador].Referencia;
                string idOrigemLetra = ObterInicial(origemLetra);
                indices["origem-letra"].AdicionarOcorrencia(idOrigemLetra.ToLower(), idOrigemLetra, origem.Identificador, origemLetra, hino);
            }

            foreach (Hino.Origem origem in hino.OrigemMusica)
            {
                string origemMusica = origens[origem.Identificador].Referencia;
                string idOrigemMusica = ObterInicial(origemMusica);
                indices["origem-musica"].AdicionarOcorrencia(idOrigemMusica.ToLower(), idOrigemMusica, origem.Identificador, origemMusica, hino);
            }

            foreach (Hino.ReferenciaBiblica referencia in hino.ReferenciasBiblicas)
            {
                string idReferencia = $"{referencia.Livro}_{referencia.Capitulo}_{referencia.Versiculos}";
                string descricaoReferencia = $"{referencia.Capitulo}.{referencia.Versiculos}";
                indices["referencia-biblica"].AdicionarOcorrencia(referencia.Livro, referencias[referencia.Livro], idReferencia, descricaoReferencia, hino);
            }

            foreach (string tituloOriginal in hino.TitulosOriginais)
            {
                string idTituloOriginal = ObterInicial(tituloOriginal);
                indices["titulo-original"].AdicionarOcorrencia(idTituloOriginal.ToLower(), idTituloOriginal, tituloOriginal, string.Empty, hino);
                indices["metrica"].AdicionarOcorrencia(hino.Metrica, metricas[hino.Metrica], tituloOriginal, string.Empty, hino);
            }

            foreach (string primeiroVersoOriginal in hino.PrimeirosVersosOriginais)
            {
                string idPrimeiroVersoOriginal = ObterInicial(primeiroVersoOriginal);
                indices["primeiro-verso-original"].AdicionarOcorrencia(idPrimeiroVersoOriginal.ToLower(), idPrimeiroVersoOriginal, RemoverTerminais(primeiroVersoOriginal), string.Empty, hino);
            }

            GravarHino(metricas, origens, referencias, caminhoXml, hino, transformer);
        }

        GravarIndices(indices);

        Console.WriteLine(sw.ElapsedMilliseconds);
    }

    private static string ObterInicial(string texto)
    {
        return Encoding.ASCII.GetString(
            Encoding.GetEncoding(
                Encoding.ASCII.CodePage, new EncoderReplacementFallback(""), new DecoderReplacementFallback("")
            ).GetBytes(
                texto.TrimStart('“')[0].ToString().Normalize(NormalizationForm.FormKD)
            )
        );
    }

    private static string RemoverTerminais(string texto)
    {
        return texto.TrimEnd('.', ',', ';', ':');
    }

    private static void GravarHino(Dictionary<string, string> metricas, Dictionary<string, (string Descricao, string Referencia)> origens, Dictionary<string, string> referencias, string caminhoXml, Hino hino, XslCompiledTransform transformer)
    {
        string caminhoSaida = $"..\\pub\\{hino.Numero}";

        if (!Directory.Exists(caminhoSaida))
        {
            Directory.CreateDirectory(caminhoSaida);
        }

        StringWriterUtf8 twSaida = new();

        transformer.Transform(caminhoXml, null, twSaida);

        string saida = twSaida.ToString();

        saida = saida.Replace(" xmlns:nc=\"http://www.novocantico.com.br/schema/hino\"", string.Empty);
        saida = saida.Replace($">{hino.Metrica}<", $">{metricas[hino.Metrica]}<");

        foreach (Hino.Origem origem in hino.OrigemLetra.Union(hino.OrigemMusica))
        {
            saida = saida.Replace($">{origem.Identificador}<", $">{origens[origem.Identificador].Descricao}<");
        }

        foreach (Hino.ReferenciaBiblica referencia in hino.ReferenciasBiblicas)
        {
            saida = saida.Replace($">{referencia.Livro}#", $">{referencias[referencia.Livro]} ");
        }

        File.WriteAllText(caminhoSaida + "\\index.html", saida);
    }

    private static void GravarIndices(Dictionary<string, Indice> indices)
    {
        XslCompiledTransform transformer = new();
        transformer.Load("indice.xsl");

        foreach (string identificador in indices.Keys)
        {
            XDocument indice = indices[identificador].ToXDocument();

            string caminhoSaida = $"..\\pub\\{identificador}";

            if (!Directory.Exists(caminhoSaida))
            {
                Directory.CreateDirectory(caminhoSaida);
            }

            StringWriterUtf8 twSaida = new();

            transformer.Transform(indice.CreateReader(ReaderOptions.None), null, twSaida);

            string saida = twSaida.ToString();

            saida = saida.Replace(", </", "</");

            File.WriteAllText(caminhoSaida + "\\index.html", saida);
        }
    }

    private class StringWriterUtf8 : StringWriter
    {
        public override System.Text.Encoding Encoding
        {
            get
            {
                return System.Text.Encoding.UTF8;
            }
        }
    }
}