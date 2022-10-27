using System.Xml;
using System.Xml.Linq;
using System.Xml.Schema;
using System.Xml.XPath;
using System.Xml.Xsl;
using NovoCantico;

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

    XDocument html = new();

    using (XmlReader xrXsl = XmlReader.Create("hino.xsl"))
    {
        XslCompiledTransform transformer = new();
        transformer.Load(xrXsl);

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
}

public class StringWriterUtf8 : StringWriter
{
    public override System.Text.Encoding Encoding
    {
        get
        {
            return System.Text.Encoding.UTF8;
        }
    }
}