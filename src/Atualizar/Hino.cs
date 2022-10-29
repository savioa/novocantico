namespace NovoCantico;

using System.Diagnostics;
using System.Xml.Linq;

[DebuggerDisplay("{Numero,nq} - {Titulo,nq}")]
public class Hino
{
    public Hino(XDocument xdHino)
    {
        XNamespace xn = xdHino.Root!.GetDefaultNamespace();

        XElement xeHino = xdHino.Element(xn + "hino")!;

        Numero = xeHino.Attribute("num")!.Value;

        Titulo = xeHino.Attribute("tit")!.Value;

        TituloAnterior = xeHino.Attribute("tit_ant") != null ? xeHino.Attribute("tit_ant")!.Value : string.Empty;

        Metrica = xeHino.Attribute("met")!.Value;

        Secao = xeHino.Attribute("sec")!.Value;

        Assunto = xeHino.Attribute("ass")!.Value;

        TitulosOriginais = xeHino.Elements(xn + "tit_ori").Select(p => p.Value).ToList();

        PrimeirosVersosOriginais = xeHino.Elements(xn + "pri_ver_ori").Select(p => p.Value).ToList();

        OrigemLetra = xeHino.Elements(xn + "ori_let").Select(l => new Origem(l)).ToList();

        OrigemMusica = xeHino.Elements(xn + "ori_mus").Select(m => new Origem(m)).ToList();

        ReferenciasBiblicas = xeHino.Elements(xn + "ref_bib").Select(r => new ReferenciaBiblica(r.Attribute("liv")!.Value, r.Attribute("cap")!.Value, r.Attribute("ver")!.Value)).ToList();

        Letra = xeHino.Element(xn + "tex")!.Elements(xn + "est").Select(e => new Estrofe(e, xn)).ToList();

        PrimeiroVerso = Letra[0].Versos[0].Texto;
    }

    public string Numero { get; set; }

    public string Titulo { get; set; }

    public string TituloAnterior { get; set; }

    public string PrimeiroVerso { get; set; }

    public string Metrica { get; set; }

    public string Secao { get; set; }

    public string Assunto { get; set; }

    public IList<string> TitulosOriginais { get; set; }

    public IList<string> PrimeirosVersosOriginais { get; set; }

    public IList<Origem> OrigemLetra { get; set; }

    public IList<Origem> OrigemMusica { get; set; }

    public IList<ReferenciaBiblica> ReferenciasBiblicas { get; set; }

    public IList<Estrofe> Letra { get; set; }

    [DebuggerDisplay("{DebuggerDisplay,nq}")]
    public class Origem
    {
        public Origem(XElement xeOrigem)
        {
            XAttribute? xaAno = xeOrigem.Attribute("ano");

            Identificador = xeOrigem.Attribute("id")!.Value;
            Ano = xaAno != null ? int.Parse(xaAno.Value) : null;
        }

        public string Identificador { get; set; }

        public int? Ano { get; set; }

        private string DebuggerDisplay => $"{Identificador}{(Ano != null ? $", {Ano}" : string.Empty)}";
    }

    [DebuggerDisplay("{DebuggerDisplay,nq}")]
    public class Estrofe
    {
        public Estrofe(XElement xeEstrofe, XNamespace xn)
        {
            Versos = xeEstrofe.Elements(xn + "ver").Select(v => new Verso(v)).ToList();

            Coros = xeEstrofe.Elements(xn + "cor").Select(c => new Estrofe(c, xn)).ToList();
        }

        public IList<Verso> Versos { get; set; }

        public IList<Estrofe> Coros { get; set; }

        private string DebuggerDisplay => $"{Versos[0].Texto} [...]";

        [DebuggerDisplay("{DebuggerDisplay,nq}")]
        public class Verso
        {
            public Verso(XElement xeVerso)
            {
                Texto = xeVerso.Value;
                Detalhe = xeVerso.Attribute("voz")?.Value;
            }

            public string Texto { get; set; }

            public string? Detalhe { get; set; }

            private string DebuggerDisplay => $"{(Detalhe != null ? $"[{Detalhe}] " : string.Empty)}{Texto}";
        }
    }

    [DebuggerDisplay("{Livro,nq} {Capitulo,nq}.{Versiculos,nq}")]
    public class ReferenciaBiblica
    {
        public ReferenciaBiblica(string livro, string capitulo, string versiculos)
        {
            Livro = livro;
            Capitulo = capitulo;
            Versiculos = versiculos;
        }

        public string Livro { get; set; }

        public string Capitulo { get; set; }

        public string Versiculos { get; set; }
    }
}