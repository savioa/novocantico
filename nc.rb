# encoding: utf-8
Encoding.default_external = 'UTF-8'
require 'rexml/document'
include REXML

class String
  def normalizar
    com_acento = 'ÀÁÂÃÄÅàáâãäåĀāĂăĄąÇçĆćĈĉĊċČčÐðĎďĐđÈÉÊËèéêëĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħÌÍÎÏìíîïĨĩĪīĬĭĮįİıĴĵĶķĸĹĺĻļĽľĿŀŁłÑñŃńŅņŇňŉŊŋÒÓÔÕÖØòóôõöøŌōŎŏŐőŔŕŖŗŘřŚśŜŝŞşŠšſŢţŤťŦŧÙÚÛÜùúûüŨũŪūŬŭŮůŰűŲųŴŵÝýÿŶŷŸŹźŻżŽž'
    sem_acento = 'AAAAAAaaaaaaAaAaAaCcCcCcCcCcDdDdDdEEEEeeeeEeEeEeEeEeGgGgGgGgHhHhIIIIiiiiIiIiIiIiIiJjKkkLlLlLlLlLlNnNnNnNnnNnOOOOOOooooooOoOoOoRrRrRrSsSsSsSssTtTtTtUUUUuuuuUuUuUuUuUuUuWwYyyYyYZzZzZz'

    self.tr(com_acento, sem_acento)
  end
end

class Hash
  def adicionar(chave, valor)
    self[chave] = Array.new unless self.has_key? chave

    self[chave] << valor
  end
end

def montar_hash_origem(xpath, xml, hash, numero, titulo)
  XPath.each(xml, xpath) { |e| hash.adicionar [e.attributes['id'], e.attributes['referencia']], [numero, titulo] }
end

def montar_hash_simples(xpath, xml, hash, numero)
  conteudo = XPath.first xml, xpath
  hash.adicionar conteudo.text.tr('“', '')[0, 1].normalizar, [numero, conteudo.text] if conteudo != nil
end

hash_origem_letra = Hash.new
hash_origem_musica = Hash.new
hash_primeiro_verso = Hash.new
hash_coro = Hash.new
hash_titulo_original = Hash.new
hash_primeiro_verso_original = Hash.new
hash_metrica = Hash.new
hash_referencia_biblica = Hash.new

Dir.chdir 'hino'
Dir.glob("**") do |hino|
  if File.directory? hino
    xml = Document.new File.new(hino + '/' + hino + '.xml')
    numero = XPath.first(xml, 'hino/numero').text
    titulo = XPath.first(xml, 'hino/titulo').text
    secao = XPath.first(xml, 'hino/secao').text
    assunto = XPath.first(xml, 'hino/assunto').text
    titulo_original = XPath.first(xml, 'hino/titulo_original').nil? ? titulo : XPath.first(xml, 'hino/titulo_original').text

    # puts numero + "|" + titulo + "|" + secao + "|" + assunto + "\n"

    montar_hash_origem 'hino/origem_letra', xml, hash_origem_letra, numero, titulo
    montar_hash_origem 'hino/origem_musica', xml, hash_origem_musica, numero, titulo
    montar_hash_simples 'hino/texto/estrofe/verso', xml, hash_primeiro_verso, numero
    montar_hash_simples 'hino/texto/estrofe/coro/verso', xml, hash_coro, numero
    montar_hash_simples 'hino/titulo_original', xml, hash_titulo_original, numero
    montar_hash_simples 'hino/primeiro_verso_original', xml, hash_primeiro_verso_original, numero
    montar_hash_origem 'hino/metrica', xml, hash_metrica, numero, titulo_original.nil? ? titulo : titulo_original
    XPath.each(xml, 'hino/referencia_biblica') { |e| hash_referencia_biblica.adicionar e.attributes['id'][0, 2], [e.text, numero, titulo, e.attributes['id']] }
  end
end

def gerar_arquivo_indice(id, conteudo, titulo, navegacao, navegacao_movel)
  modelo = File.open('../indice.modelo.html', 'r:UTF-8', &:read)
  File.write '../indice/%s/index.html' % id, modelo.gsub('conteudo-indice', conteudo).gsub('titulo-indice', titulo).gsub('navegacao-indice', navegacao).gsub('navegacao-movel-indice', navegacao_movel)
end

def gerar_saida_origem(hash, id, titulo)
  navegacao_movel = ' ' * 32 + '<ul id=\'navegacao-movel\' class="nav nav-pills hidden-lg hidden-md">' + "\n"
  navegacao = ' ' * 28 + '<ul class="nav nav-pills">' + "\n"
  conteudo = ''

  hash.keys.sort.each_with_index do |chave, posicao|
    indice = hash[chave]

    unless conteudo.include? '>%s<' % chave[0][0, 1]
      if posicao > 0
        conteudo << ' ' * 40 + '</ul>' + "\n"
        conteudo << ' ' * 36 + '</li>' + "\n"
      end

      navegacao << ' ' * 32 + '<li role="presentation"><a href="#%s">%s</a></li>' % [chave[0][0, 1].downcase, chave[0][0, 1]] + "\n"
      navegacao_movel << ' ' * 36 + '<li role="presentation"><a href="#%s">%s</a></li>' % [chave[0][0, 1].downcase, chave[0][0, 1]] + "\n"

      conteudo << ' ' * 36 + '<li id=\'%s\'><h2>%s</h2> <a class=\'hidden-lg hidden-md\' title=\'Ir para o topo\' href=\'#navegacao-movel\'><i class=\'fa fa-level-up\'></i></a>' % [chave[0][0, 1].downcase, chave[0][0, 1]] + "\n"
      conteudo <<  ' ' * 40 + '<ul class=\'list-unstyled\'>' + "\n"
    end

    conteudo <<  ' ' * 44 + '<li id=\'%s\'>%s: ' % [chave[0], chave[1]]

    conteudo <<  indice.collect(&:first).collect{ |n| '<a href=\'../../hino/%s/%s.xml\'>%s</a>' % [n, n, n] }.join(', ')

    conteudo << '</li>' + "\n"
  end

  conteudo << ' ' * 40 + '</ul>' + "\n"
  conteudo << ' ' * 36 + '</li>'
  navegacao << ' ' * 28 + '</ul>'
  navegacao_movel << ' ' * 32 + '</ul>' + "\n"

  gerar_arquivo_indice id, conteudo, titulo, navegacao, navegacao_movel
end

def gerar_saida_simples(hash, id, titulo)
  navegacao_movel = ' ' * 32 + '<ul id=\'navegacao-movel\' class="nav nav-pills hidden-lg hidden-md">' + "\n"
  navegacao = ' ' * 28 + '<ul class="nav nav-pills">' + "\n"
  conteudo = ''

  hash.sort.each do |chave, valor|
    navegacao << ' ' * 32 + '<li role="presentation"><a href="#%s">%s</a></li>' % [chave.downcase, chave] + "\n"
    navegacao_movel << ' ' * 36 + '<li role="presentation"><a href="#%s">%s</a></li>' % [chave.downcase, chave] + "\n"

    conteudo << ' ' * 36 + '<li id=\'%s\'><h2>%s</h2> <a class=\'hidden-lg hidden-md\' title=\'Ir para o topo\' href=\'#navegacao-movel\'><i class=\'fa fa-level-up\'></i></a>' % [chave.downcase, chave] + "\n"
    conteudo <<  ' ' * 40 + '<ul class=\'list-unstyled\'>' + "\n"
    valor.sort!{ |a, b| a[1].normalizar <=> b[1].normalizar}.each do |e|
      conteudo << ' ' * 44 + '<li id=\'%s\'><a href=\'../../hino/%s/%s.xml\'>%s</a>: %s</li>' % [e[0], e[0], e[0], e[1].gsub(/[,;:.!?]$/, ''), e[0]] + "\n"
    end
    conteudo << ' ' * 40 + '</ul>' + "\n"
    conteudo << ' ' * 36 + '</li>' + "\n"
  end

  navegacao << ' ' * 28 + '</ul>'
  navegacao_movel << ' ' * 32 + '</ul>' + "\n"

  gerar_arquivo_indice id, conteudo, titulo, navegacao, navegacao_movel
end

gerar_saida_origem hash_origem_letra, 'origem-letra', 'Origem da Letra'
gerar_saida_origem hash_origem_musica, 'origem-musica', 'Origem da Música'
gerar_saida_simples hash_primeiro_verso, 'primeiro-verso', 'Primeiro Verso'
gerar_saida_simples hash_coro, 'coro', 'Coro'
gerar_saida_simples hash_titulo_original, 'titulo-original', 'Título Original'
gerar_saida_simples hash_primeiro_verso_original, 'primeiro-verso-original', 'Primeiro Verso Original'

# Métrica
conteudo = ''
hash_metrica.sort.each do |chave, valor|
  conteudo << ' ' * 36 + '<li id=\'%s\'><h2>%s</h2>' % [chave[0], chave[0].gsub('_', '.')] + "\n"
  conteudo <<  ' ' * 40 + '<ul class=\'list-unstyled\'>' + "\n"

  valor.each do |e|
    conteudo << ' ' * 44 + '<li><a href=\'../../hino/%s/%s.xml\'>%s</a>: %s</li>' % [e[0], e[0], e[1].gsub(/[,;:.!?]$/, ''), e[0]] + "\n"
  end

  conteudo << ' ' * 40 + '</ul>' + "\n"
  conteudo << ' ' * 36 + '</li>' + "\n"
end

gerar_arquivo_indice 'metrica', conteudo, 'Métrica', '', ''

# Referência bíblica
livros = { '01' => ['Gênesis', 'Gn'], '02' => ['Êxodo', 'Êx'], '03' => ['Levítico', 'Lv'], '04' => ['Números', 'Nm'], '05' => ['Deuteronômio', 'Dt'], '06' => ['José', 'Js'], '07' => ['Juíes', 'Jz'], '08' => ['Rute', 'Rt'], '09' => ['1 Samuel', '1Sm'], '10' => ['2 Samuel', '2Sm'], '11' => ['1 Reis', '1Rs'], '12' => ['2 Reis', '2Rs'], '13' => ['1 Crônicas', '1Cr'], '14' => ['2 Crônicas', '2Cr'], '15' => ['Esdras', 'Ed'], '16' => ['Neemias', 'Ne'], '17' => ['Ester', 'Et'], '18' => ['Jó', 'Jó'], '19' => ['Salmos', 'Sl'], '20' => ['Provérbios', 'Pv'], '21' => ['Eclesiastes', 'Ec'], '22' => ['Cantares', 'Ct'], '23' => ['Isaías', 'Is'], '24' => ['Jeremias', 'Jr'], '25' => ['Lamentações', 'Lm'], '26' => ['Ezequiel', 'Ez'], '27' => ['Daniel', 'Dn'], '28' => ['Oséias', 'Os'], '29' => ['Joel', 'Jl'], '30' => ['Amós', 'Am'], '31' => ['Obadias', 'Ob'], '32' => ['Jonas', 'Jn'], '33' => ['Miqéias', 'Mq'], '34' => ['Naum', 'Na'], '35' => ['Habacuque', 'Hc'], '36' => ['Sofonias', 'Sf'], '37' => ['Ageu', 'Ag'], '38' => ['Zacarias', 'Zc'], '39' => ['Malaquias', 'Ml'], '40' => ['Mateus', 'Mt'], '41' => ['Marcos', 'Mc'], '42' => ['Lucas', 'Lc'], '43' => ['João', 'Jo'], '44' => ['Atos', 'At'], '45' => ['Romanos', 'Rm'], '46' => ['1 Coríntios', '1Co'], '47' => ['2 Coríntios', '2Co'], '48' => ['Gálatas', 'Gl'], '49' => ['Efésios', 'Ef'], '50' => ['Filipenses', 'Fl'], '51' => ['Colossenses', 'Cl'], '52' => ['1 Tessalonicenses', '1Ts'], '53' => ['2 Tessalonicenses', '2Ts'], '54' => ['1 Timóteo', '1Tm'], '55' => ['2 Timóteo', '2Tm'], '56' => ['Tito', 'Tt'], '57' => ['Filemon', 'Fl'], '58' => ['Hebreus', 'Hb'], '59' => ['Tiago', 'Tg'], '60' => ['1 Pedro', '1Pe'], '61' => ['2 Pedro', '2Pe'], '62' => ['1 João', '1Jo'], '63' => ['2 João', '2Jo'], '64' => ['3 João', '3Jo'], '65' => ['Judas', 'Jd'], '66' => ['Apocalipse', 'Ap'] }

navegacao_movel = ' ' * 32 + '<ul id=\'navegacao-movel\' class="nav nav-pills hidden-lg hidden-md">' + "\n"
navegacao = ' ' * 28 + '<ul class="nav nav-pills">' + "\n"
conteudo = ''

hash_referencia_biblica.sort.each do |chave, valor|
  navegacao << ' ' * 32 + '<li role="presentation"><a href="#%s">%s</a></li>' % [chave, livros[chave][1]] + "\n"
  navegacao_movel << ' ' * 36 + '<li role="presentation"><a href="#%s">%s</a></li>' % [chave, livros[chave][1]] + "\n"

  conteudo << ' ' * 36 + '<li id=\'%s\'><h2>%s</h2> <a class=\'hidden-lg hidden-md\' title=\'Ir para o topo\' href=\'#navegacao-movel\'><i class=\'fa fa-level-up\'></i></a>' % [chave, livros[chave][0]] + "\n"
  conteudo <<  ' ' * 40 + '<ul class=\'list-unstyled\'>' + "\n"

  valor.sort!{ |a, b| a[3] <=> b[3]}.each do |e|
    conteudo << ' ' * 44 + '<li id=\'%s\'>%s <a href=\'../../hino/%s/%s.xml\'>%s</a>: %s</li>' % [e[3], e[0].gsub(livros[chave][0] + ' ' , ''), e[1], e[1], e[2].gsub(/[,;:.!?]$/, ''), e[1]] + "\n"
  end

  conteudo << ' ' * 40 + '</ul>' + "\n"
  conteudo << ' ' * 36 + '</li>' + "\n"
end

navegacao << ' ' * 28 + '</ul>'
navegacao_movel << ' ' * 32 + '</ul>' + "\n"

gerar_arquivo_indice 'referencia-biblica', conteudo, 'Referência Bíblica', navegacao, navegacao_movel

# Assunto
secaoAtual = 'nenhuma'
assuntoAtual = 'nenhum'
conteudo = ''

File.open("../listagemComAssunto", "r") do |f|
  f.each_line do |linha|
    item = linha.split '|'
    numero = item[0].strip
    titulo = item[1].strip
    secao = item[2].strip.split '#'
    nomeSecao = secao[0]
    indiceSecao = secao[1]
    assunto = item[3].strip.split '#'
    nomeAssunto = assunto[0]
    indiceAssunto = assunto[1]

    quebra_secao = false

    if nomeSecao != secaoAtual
      if secaoAtual != 'nenhuma'
        # Fecha assunto
        conteudo << ' ' * 48 + '</ul>' + "\n"
        conteudo << ' ' * 44 + '</li>' + "\n"

        # Fecha seção
        conteudo << ' ' * 40 + '</ul>' + "\n"
        conteudo << ' ' * 36 + '</li>' + "\n"

        quebra_secao = true
      end

      secaoAtual = nomeSecao

      conteudo << ' ' * 36 + '<li id=\'%s\'><h2>%s' % [indiceSecao, nomeSecao] + "</h2>\n"
      conteudo << ' ' * 40 + '<ul class=\'list-unstyled\'>' + "\n"
    end

    if nomeAssunto != assuntoAtual
      if quebra_secao
        quebra_secao = false
      else
        if assuntoAtual != 'nenhum'
          conteudo << ' ' * 48 + '</ul>' + "\n"
          conteudo << ' ' * 44 + '</li>' + "\n"
        end
      end

      assuntoAtual = nomeAssunto

      conteudo << ' ' * 44 + '<li id=\'%s%s\'><h3>%s' % [indiceSecao, indiceAssunto, nomeAssunto] + "</h3>\n"
      conteudo << ' ' * 48 + '<ul class=\'list-unstyled\'>' + "\n"
    end

    if File.exist?('%s' % numero)
      conteudo << ' ' * 52 + '<li><a href=\'../../hino/%s/%s.xml\'>%s · %s</a></li>' % [numero, numero, numero, titulo] + "\n"
    else
      conteudo << ' ' * 52 + '<li>%s · %s</li>' % [numero, titulo] + "\n"
    end
  end
end

conteudo << ' ' * 40 + '</ul>' + "\n"
conteudo << ' ' * 38 + '</li>' + "\n"

gerar_arquivo_indice 'assunto', conteudo, 'Assunto', '', ''