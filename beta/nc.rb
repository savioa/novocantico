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
  XPath.each(xml, xpath) { |e| hash.adicionar [e.attributes['id'], e.text], [numero, titulo] }
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

raiz = '/Users/elleralmeida/Documents/novocantico/hino/'
Dir.foreach raiz do |hino|
  unless hino.start_with? '.'
    xml = Document.new File.new(raiz + hino + '/' + hino + '.xml')
    numero = XPath.first(xml, 'hino/numero').text
    titulo = XPath.first(xml, 'hino/titulo').text

    montar_hash_origem 'hino/origem_letra', xml, hash_origem_letra, numero, titulo
    montar_hash_origem 'hino/origem_musica', xml, hash_origem_musica, numero, titulo
    montar_hash_simples 'hino/texto/estrofe/verso', xml, hash_primeiro_verso, numero
    montar_hash_simples 'hino/texto/estrofe/coro/verso', xml, hash_coro, numero
    montar_hash_simples 'hino/titulo_original', xml, hash_titulo_original, numero
    montar_hash_simples 'hino/primeiro_verso_original', xml, hash_primeiro_verso_original, numero
    montar_hash_origem 'hino/metrica', xml, hash_metrica, numero, titulo
    XPath.each(xml, 'hino/referencia_biblica') { |e| hash_referencia_biblica.adicionar e.attributes['id'][0, 2], [e.text, numero, titulo] }
  end
end

navegacao_primeiro_verso = ' ' * 28 + '<ul class="nav nav-pills">' + "\n"
conteudo_primeiro_verso = ''

hash_primeiro_verso.sort.each do |chave, valor|
  navegacao_primeiro_verso << ' ' * 32 + '<li role="presentation"><a href="#%s">%s</a></li>' % [chave.downcase, chave] + "\n"

  conteudo_primeiro_verso << ' ' * 36 + '<li><span id=\'%s\'>%s</span>' % [chave.downcase, chave] + "\n"
  conteudo_primeiro_verso <<  ' ' * 40 + '<ul class=\'list-unstyled\'>' + "\n"
  valor.sort!{ |a, b| a[1].normalizar <=> b[1].normalizar}.each do |e|
    conteudo_primeiro_verso << ' ' * 44 + '<li><a href=\'../../hino/%s/%s.xml\'>%s</a>: %s</li>' % [e[0], e[0], e[1].gsub(/[,;:.!?]$/, ''), e[0]] + "\n"
  end
  conteudo_primeiro_verso << ' ' * 40 + '</ul>' + "\n"
  conteudo_primeiro_verso << ' ' * 36 + '</li>'
end

navegacao_primeiro_verso << ' ' * 28 + '</ul>'

conteudo = File.open('indice.modelo.html', 'r:UTF-8', &:read)
File.write'indice/primeiro-verso/index.html', conteudo.gsub('navegacao-indice', navegacao_primeiro_verso).gsub('conteudo-indice', conteudo_primeiro_verso).gsub('titulo-indice', 'Primeiro Verso')
