<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>
<xsl:output method='html' encoding='utf-8' indent='yes' doctype-public='-//W3C//DTD XHTML 1.1//EN' doctype-system='http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd'/>
<xsl:template match='/'>
<html xmlns='http://www.w3.org/1999/xhtml' lang='en' xml:lang='en'>
<head>
	<title><xsl:value-of select='hino/numero'/> - <xsl:value-of select='hino/titulo'/> - Novo Cântico</title>
	<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
	<link rel='stylesheet' type='text/css' href='../../css/reset_em.css' />
	<link rel='stylesheet' type='text/css' href='../../css/base.css' />
	<script type='text/javascript' src='../../js/jquery-1.3.2.min.js'></script>
	<script type='text/javascript' src='../../js/cifra-2009-08-28.js'></script>

</head>

<body>

<div id='cabecalho'>
	<h1><a href='/'>Novo Cântico</a></h1>
	<h2><a href='/'>Hinário Presbiteriano</a></h2>

	<div id='menu'>
		<ul>
			<li><a href='../../indiceAssunto.html'>Índice</a></li>
			<li><a href='../../artigos.html'>Artigos</a></li>
			<li><a href='../../sobre.html'>Sobre</a></li>
			<li><a href='../../contato.html'>Contato</a></li>
			<li><a href='../../hnc_v001.epub'>E-book (ePub)</a></li>
		</ul>

		<form action='http://www.novocantico.com.br/busca.html' id='cse-search-box'>
			<fieldset>
				<input type='text' name='q' id='busca' />
				<input type='hidden' name='cx' value='007541164279382477135:v55cgb2k3be' />
				<input type='hidden' name='cof' value='FORID:9' />
				<input type='hidden' name='ie' value='UTF-8' /> <button type='submit' name='sa'>Buscar</button>
			</fieldset>
		</form>
	</div>
</div>

<div id='conteudo'>
	<h1><span id='numero'><xsl:value-of select='hino/numero'/>.</span><span id='titulo'><xsl:value-of select='hino/titulo'/></span></h1>

	<div id='hino'>
		<p><a href='../../indiceAssunto.html#{/hino/secao/@id}'><xsl:value-of select='hino/secao'/></a> &#8250; <a href='../../indiceAssunto.html#{/hino/secao/@id}{/hino/assunto/@id}'><xsl:value-of select='hino/assunto'/></a></p>

		<ul id='texto'>
		<xsl:for-each select='hino/texto/estrofe'>
			<li><ul>
				<xsl:for-each select='verso'>
					<xsl:if test='hino/@cifra'>
						<item last="{/values/value[position()-1]}" current="{.}" />
					</xsl:if>
					<li><xsl:if test='@voz'><span class='voz'>[<xsl:value-of select='./@voz'/>]</span>&#160;</xsl:if><xsl:value-of select='.'/></li>
				</xsl:for-each>
				</ul>

				<xsl:for-each select='coro'>
				<ul class='coro'>
					<xsl:if test='@voz'><li><span class='voz'>[<xsl:value-of select='./@voz'/>]</span></li></xsl:if>
					<xsl:for-each select='verso'>
						<li><xsl:if test='@voz'><span class='voz'>[<xsl:value-of select='./@voz'/>]</span>&#160;</xsl:if><xsl:value-of select='.'/></li>
					</xsl:for-each>
				</ul>

				</xsl:for-each>
			</li>
		</xsl:for-each>
		</ul>

		<xsl:if test='hino/@cifra'>
		<ul id='cifra'>
		<xsl:for-each select='hino/texto/estrofe'>
			<xsl:for-each select='verso | cifra'>
				<li><pre><xsl:value-of select='.'/></pre></li>
			</xsl:for-each>

			<xsl:for-each select='coro'>
				<li>
					<ul class='cifra_coro'>
					<xsl:for-each select='verso | cifra'>
						<li><pre><xsl:value-of select='.'/></pre></li>
					</xsl:for-each>
					</ul>
				</li>
			</xsl:for-each>
		</xsl:for-each>
		</ul>
		</xsl:if>
	</div>

	<div id='info'>
		<ul>
			<xsl:if test='hino/@cifra'>
			<li id='mostrar' class='link_cifra'><a>Mostrar cifra</a><ul></ul></li>
			<li id='ocultar' class='link_cifra'><a>Ocultar cifra</a><ul></ul></li>
			</xsl:if>

			<xsl:choose>
			<xsl:when test='hino/@situacao'>
			<li>Partitura
				<ul><li>(Em breve)</li></ul>
			</li>
			<li>Áudio
				<ul><li>(Em breve)</li></ul>
			</li>
			</xsl:when>
			<xsl:otherwise>
			<li><a href='{hino/numero}.pdf'>Partitura</a><ul></ul></li>
			<li>Áudio
				<ul>
					<li><a href='{hino/numero}.mid'>4 vozes</a></li>
					<li><a href='{hino/numero}s.mid'>Soprano</a></li>
					<li><a href='{hino/numero}c.mid'>Contralto</a></li>
					<li><a href='{hino/numero}t.mid'>Tenor</a></li>
					<li><a href='{hino/numero}b.mid'>Baixo</a></li>
				</ul>
			</li>
			</xsl:otherwise>
			</xsl:choose>

			<li>Origem da Letra
				<ul>
					<xsl:for-each select='hino/origem_letra'>
					<li>
					<a href='../../indiceOrigemLetra.html#{./@id}'><xsl:value-of select='.'/></a>
					<xsl:if test='./@ano'> (<xsl:value-of select='./@ano'/>)</xsl:if>
					</li>
					</xsl:for-each>
				</ul>
			</li>
			<li>Origem da Música
				<ul>
					<xsl:for-each select='hino/origem_musica'>
					<li>
					<a href='../../indiceOrigemMusica.html#{./@id}'><xsl:value-of select='.'/></a>
					<xsl:if test='./@ano'> (<xsl:value-of select='./@ano'/>)</xsl:if>
					</li>
					</xsl:for-each>
				</ul>
			</li>
			<li>Referência Bíblica
				<ul>
					<xsl:for-each select='hino/referencia_biblica'>
					<li><a href='../../indiceReferenciaBiblica.html#{./@id}'><xsl:value-of select='.'/></a></li>
					</xsl:for-each>
				</ul>
			</li>
			<li>Título Original
				<ul>
					<xsl:for-each select='hino/titulo_original'>
					<li><a href='../../indiceTituloOriginal.html#{/hino/numero}'><xsl:value-of select='.'/></a></li>
					</xsl:for-each>
				</ul>
			</li>
			<li>1º Verso Original
				<ul>
					<xsl:for-each select='hino/primeiro_verso_original'>
					<li><a href='../../indicePrimVersoOriginal.html#{/hino/numero}'><xsl:value-of select='.'/></a></li>
					</xsl:for-each>
				</ul>
			</li>
			<li>Métrica
				<ul>
					<xsl:for-each select='hino/metrica'>
					<li><a href='../../indiceMetrica.html#{/hino/metrica/@id}'><xsl:value-of select='.'/></a></li>
					</xsl:for-each>
				</ul>
			</li>
		</ul>
	</div>
	<p id='rodape'>Entoai-lhe novo cântico, tangei com arte e com júbilo. Salmo 33.3</p>
</div>
<script type="text/javascript" src=" http://www.google-analytics.com/urchin.js "></script>

<script type="text/javascript">
_uacct = "UA-9463013-1"
urchinTracker();
</script>
</body>
</html>
</xsl:template>
</xsl:stylesheet>
