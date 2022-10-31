namespace NovoCantico;

using System.Diagnostics;
using System.Xml.Linq;

[DebuggerDisplay("{Nome,nq}")]
public class Indice
{
    public Indice(string nome)
    {
        Nome = nome;
        Grupos = new List<Grupo>();
    }

    public string Nome { get; set; }

    public IList<Grupo> Grupos { get; set; }

    public void AdicionarOcorrencia(string valorGrupo, string descricaoGrupo, string valorTermo, string descricaoTermo, Hino hino, string valorGrupoOrdenacao = "")
    {
        Grupo? grupo = Grupos.FirstOrDefault(g => g.Valor == valorGrupo);

        if (grupo == null)
        {
            grupo = new(valorGrupo, descricaoGrupo, valorGrupoOrdenacao);
            Grupos.Add(grupo);
        }

        grupo.AdicionarOcorrencia(valorTermo, descricaoTermo, hino);
    }

    public XDocument ToXDocument()
    {
        XDocument xdIndice = new();

        XElement xeIndice = new("indice");
        xdIndice.Add(xeIndice);

        xeIndice.Add(new XAttribute("nome", Nome));

        foreach (Grupo grupo in Grupos.OrderBy(g => g.ValorOrdenacao))
        {
            xdIndice.Element("indice")!.Add(grupo.ToXElement());
        }

        return xdIndice;
    }

    [DebuggerDisplay("{Descricao,nq}")]
    public class Grupo
    {
        public Grupo(string valor, string descricao, string valorOrdenacao = "")
        {
            Valor = valor;
            Descricao = descricao;
            ValorOrdenacao = !string.IsNullOrEmpty(valorOrdenacao) ? valorOrdenacao : valor;
            Termos = new List<Termo>();
        }

        public string Valor { get; set; }

        public string Descricao { get; set; }

        public string ValorOrdenacao { get; set; }

        public IList<Termo> Termos { get; set; }

        public XElement ToXElement()
        {
            XElement xeGrupo = new("grupo");
            xeGrupo.Add(new XAttribute("valor", Valor));
            xeGrupo.Add(new XAttribute("descricao", Descricao));

            foreach (Termo termo in Termos.OrderBy(t => t.Valor))
            {
                xeGrupo.Add(termo.ToXElement());
            }

            return xeGrupo;
        }

        public void AdicionarOcorrencia(string valorTermo, string descricaoTermo, Hino hino)
        {
            Termo? termo = Termos.FirstOrDefault(t => t.Valor == valorTermo);

            if (termo == null)
            {
                termo = new(valorTermo, descricaoTermo);
                Termos.Add(termo);
            }

            termo.Ocorrencias.Add(new Termo.Ocorrencia(hino));
        }

        [DebuggerDisplay("{Descricao,nq}")]
        public class Termo
        {
            public Termo(string valor, string descricao)
            {
                Valor = valor;
                Descricao = descricao;
                Ocorrencias = new List<Ocorrencia>();
            }

            public string Valor { get; set; }

            public string Descricao { get; set; }

            public IList<Ocorrencia> Ocorrencias { get; set; }

            public XElement ToXElement()
            {
                XElement xeTermo = new("termo");
                xeTermo.Add(new XAttribute("valor", Valor));

                if (!string.IsNullOrEmpty(Descricao))
                {
                    xeTermo.Add(new XAttribute("descricao", Descricao));
                }

                foreach (Ocorrencia ocorrencia in Ocorrencias.OrderBy(o => o.Valor))
                {
                    xeTermo.Add(ocorrencia.ToXElement());
                }

                return xeTermo;
            }

            [DebuggerDisplay("{Valor,nq} - {Descricao,nq}")]
            public class Ocorrencia
            {
                public Ocorrencia(Hino hino)
                {
                    Valor = hino.Numero;
                    Descricao = hino.Titulo;
                    TituloAnterior = hino.TituloAnterior;
                }

                public string Valor { get; set; }

                public string Descricao { get; set; }

                public string TituloAnterior { get; set; }

                public XElement ToXElement()
                {
                    XElement xeOcorrencia = new("ocorrencia");
                    xeOcorrencia.Add(new XAttribute("valor", Valor));
                    xeOcorrencia.Add(new XAttribute("descricao", Descricao));

                    if (!string.IsNullOrEmpty(TituloAnterior))
                    {
                        xeOcorrencia.Add(new XAttribute("tituloAnterior", TituloAnterior));
                    }

                    return xeOcorrencia;
                }
            }
        }
    }
}