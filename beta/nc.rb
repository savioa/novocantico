# encoding: utf-8

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

raiz = '../hino/'
Dir.foreach raiz do |hino|
  unless hino.start_with? '.'
    xml = Document.new File.new(raiz + hino + '/' + hino + '.xml')
    numero = XPath.first(xml, 'hino/numero').text
    titulo = XPath.first(xml, 'hino/titulo').text

    # montar_hash_origem 'hino/origem_letra', xml, hash_origem_letra, numero, titulo
    # montar_hash_origem 'hino/origem_musica', xml, hash_origem_musica, numero, titulo
    montar_hash_simples 'hino/texto/estrofe/verso', xml, hash_primeiro_verso, numero
    # montar_hash_simples 'hino/texto/estrofe/coro/verso', xml, hash_coro, numero
    # montar_hash_simples 'hino/titulo_original', xml, hash_titulo_original, numero
    # montar_hash_simples 'hino/primeiro_verso_original', xml, hash_primeiro_verso_original, numero
    montar_hash_origem 'hino/metrica', xml, hash_metrica, numero, titulo
    # XPath.each(xml, 'hino/referencia_biblica') { |e| hash_referencia_biblica.adicionar e.attributes['id'][0, 2], [e.text, numero, titulo] }
  end
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

      conteudo << ' ' * 36 + '<li><span id=\'%s\'>%s</span> <a class=\'hidden-lg hidden-md\' title=\'Ir para o topo\' href=\'#navegacao-movel\'><i class=\'fa fa-level-up\'></i></a>' % [chave[0][0, 1].downcase, chave[0][0, 1]] + "\n"
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

  modelo = File.open('indice.modelo.html', 'r:UTF-8', &:read)
  File.write 'indice/%s/index.html' % id, modelo.gsub('navegacao-indice', navegacao).gsub('conteudo-indice', conteudo).gsub('titulo-indice', titulo).gsub('navegacao-movel-indice', navegacao_movel)
end

def gerar_saida_simples(hash, id, titulo)
  navegacao_movel = ' ' * 32 + '<ul id=\'navegacao-movel\' class="nav nav-pills hidden-lg hidden-md">' + "\n"
  navegacao = ' ' * 28 + '<ul class="nav nav-pills">' + "\n"
  conteudo = ''

  hash.sort.each do |chave, valor|
    navegacao << ' ' * 32 + '<li role="presentation"><a href="#%s">%s</a></li>' % [chave.downcase, chave] + "\n"
    navegacao_movel << ' ' * 36 + '<li role="presentation"><a href="#%s">%s</a></li>' % [chave.downcase, chave] + "\n"

    conteudo << ' ' * 36 + '<li><span id=\'%s\'>%s</span> <a class=\'hidden-lg hidden-md\' title=\'Ir para o topo\' href=\'#navegacao-movel\'><i class=\'fa fa-level-up\'></i></a>' % [chave.downcase, chave] + "\n"
    conteudo <<  ' ' * 40 + '<ul class=\'list-unstyled\'>' + "\n"
    valor.sort!{ |a, b| a[1].normalizar <=> b[1].normalizar}.each do |e|
      conteudo << ' ' * 44 + '<li><a href=\'../../hino/%s/%s.xml\'>%s</a>: %s</li>' % [e[0], e[0], e[1].gsub(/[,;:.!?]$/, ''), e[0]] + "\n"
    end
    conteudo << ' ' * 40 + '</ul>' + "\n"
    conteudo << ' ' * 36 + '</li>' + "\n"
  end

  navegacao << ' ' * 28 + '</ul>'
  navegacao_movel << ' ' * 32 + '</ul>' + "\n"

  modelo = File.open('indice.modelo.html', 'r:UTF-8', &:read)
  File.write 'indice/%s/index.html' % id, modelo.gsub('navegacao-indice', navegacao).gsub('conteudo-indice', conteudo).gsub('titulo-indice', titulo).gsub('navegacao-movel-indice', navegacao_movel)
end

conteudo = ''
hash_metrica.sort.each do |chave, valor|
  conteudo << ' ' * 36 + '<li><span id=\'%s\'>%s</span> <a class=\'hidden-lg hidden-md\' title=\'Ir para o topo\' href=\'#navegacao-movel\'><i class=\'fa fa-level-up\'></i></a>' % [chave[0], chave[0].gsub('_', '.')] + "\n"
  conteudo <<  ' ' * 40 + '<ul class=\'list-unstyled\'>' + "\n"
  conteudo << ' ' * 40 + '</ul>' + "\n"
  conteudo << ' ' * 36 + '</li>' + "\n"
end

modelo = File.open('indice.modelo.html', 'r:UTF-8', &:read)
File.write 'indice/metrica/index.html', modelo.gsub('conteudo-indice', conteudo).gsub('titulo-indice', 'Métrica').gsub('navegacao-indice', '').gsub('navegacao-movel-indice', '')

# gerar_saida_origem hash_origem_letra, 'origem-letra', 'Origem da Letra'
# gerar_saida_origem hash_origem_musica, 'origem-musica', 'Origem da Música'
gerar_saida_simples hash_primeiro_verso, 'primeiro-verso', 'Primeiro Verso'
# gerar_saida_simples hash_coro, 'coro', 'Coro'
# gerar_saida_simples hash_titulo_original, 'titulo-original', 'Título Original'
# gerar_saida_simples hash_primeiro_verso_original, 'primeiro-verso-original', 'Primeiro Verso Original'
