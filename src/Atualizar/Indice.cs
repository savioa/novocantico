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
            grupo = new(this, valorGrupo, descricaoGrupo, valorGrupoOrdenacao);
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
        public Grupo(Indice pai, string valor, string descricao, string valorOrdenacao = "")
        {
            Pai = pai;
            Valor = valor;
            Descricao = descricao;
            ValorOrdenacao = !string.IsNullOrEmpty(valorOrdenacao) ? valorOrdenacao : valor;
            Termos = new List<Termo>();
        }

        public Indice Pai { get; set; }

        public string Valor { get; set; }

        public string Descricao { get; set; }

        public string ValorOrdenacao { get; set; }

        public IList<Termo> Termos { get; set; }

        public XElement ToXElement()
        {
            XElement xeGrupo = new("grupo");
            xeGrupo.Add(new XAttribute("valor", Valor));
            xeGrupo.Add(new XAttribute("descricao", Descricao));

            foreach (Termo termo in Termos.OrderBy(t => t.ValorOrdenacao))
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
                termo = new(this, valorTermo, descricaoTermo);
                Termos.Add(termo);
            }

            termo.Ocorrencias.Add(new Termo.Ocorrencia(termo, hino));
        }

        [DebuggerDisplay("{Descricao,nq}")]
        public class Termo
        {
            public Termo(Grupo pai, string valor, string descricao, string valorOrdencao = "")
            {
                Pai = pai;
                Valor = valor;
                Descricao = descricao;
                ValorOrdenacao = string.IsNullOrEmpty(valorOrdencao) ? valor : valorOrdencao;
                Ocorrencias = new List<Ocorrencia>();

                if (pai.Pai.Nome == "Referência Bíblica")
                {
                    string[] itens = valor.Split("_");
                    string[] versiculos = itens[2].Split(',', '-', ';');
                   
                    ValorOrdenacao = string.Join('_', itens[0], itens[1].PadLeft(3, '0'), string.Join('_', versiculos.Select(v => v.PadLeft(3, '0'))));
                }
            }

            public Grupo Pai { get; set; }

            public string Valor { get; set; }

            public string Descricao { get; set; }

            public string ValorOrdenacao { get; set; }

            public IList<Ocorrencia> Ocorrencias { get; set; }

            public XElement ToXElement()
            {
                XElement xeTermo = new("termo");
                xeTermo.Add(new XAttribute("valor", Valor));

                if (!string.IsNullOrEmpty(Descricao))
                {
                    xeTermo.Add(new XAttribute("descricao", Descricao));
                }

                foreach (Ocorrencia ocorrencia in Ocorrencias.OrderBy(o => o.ValorOrdenacao))
                {
                    xeTermo.Add(ocorrencia.ToXElement());
                }

                return xeTermo;
            }

            [DebuggerDisplay("{Valor,nq} - {Descricao,nq}")]
            public class Ocorrencia
            {
                public Ocorrencia(Termo pai, Hino hino)
                {
                    Pai = pai;
                    Valor = hino.Numero;
                    Descricao = hino.Titulo;
                    TitulosAnteriores = hino.TitulosAnteriores;
                    ValorOrdenacao = hino.Numero.PadLeft(3, '0');
                }

                public Termo Pai { get; set; }

                public string Valor { get; set; }

                public string Descricao { get; set; }

                public IList<string> TitulosAnteriores { get; set; }

                public string ValorOrdenacao { get; set; }

                public XElement ToXElement()
                {
                    XElement xeOcorrencia = new("ocorrencia");
                    xeOcorrencia.Add(new XAttribute("valor", Valor));
                    xeOcorrencia.Add(new XAttribute("descricao", Descricao));

                    if (TitulosAnteriores.Any())
                    {
                        xeOcorrencia.Add(new XAttribute("tituloAnterior", string.Join("; ", TitulosAnteriores)));
                    }

                    return xeOcorrencia;
                }
            }
        }
    }
}