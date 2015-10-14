<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>
    <xsl:output method='html' encoding='utf-8' indent='yes' />
    <xsl:template match='/'>
    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
<html lang="pt-br">
    <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />

        <title><xsl:value-of select='hino/numero'/> · <xsl:value-of select='hino/titulo'/> · Novo Cântico</title>

        <link href="https://maxcdn.bootstrapcdn.com/bootswatch/3.3.4/cosmo/bootstrap.min.css" rel="stylesheet" />
        <link href="http://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" />
        <link href="../../css/nc.css" rel="stylesheet" />

        <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
        <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
        <![endif]-->
    </head>

    <body>
        <nav class="navbar navbar-inverse navbar-static-top">
            <div class="container">
                <div class="container-fluid">
                    <div class="navbar-header">
                        <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-2">
                            <span class="sr-only">Acionar menu de navegação</span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>
                        <a class="navbar-brand" href="../../index.html">Novo Cântico</a>
                    </div>

                    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-2">
                        <ul class="nav navbar-nav">
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">Índices <span class="caret"></span></a>
                                <ul class="dropdown-menu" role="menu">
                                    <li><a href="../../indice/assunto">Número/Assunto</a></li>
                                    <li><a href="../../indice/primeiro-verso">Primeiro Verso</a></li>
                                    <li><a href="../../indice/coro">Coro</a></li>
                                    <li class="divider"></li>
                                    <li><a href="../../indice/origem-letra">Origem da Letra</a></li>
                                    <li><a href="../../indice/origem-musica">Origem da Música</a></li>
                                    <li><a href="../../indice/referencia-biblica">Referência Bíblica</a></li>
                                    <li><a href="../../indice/titulo-original">Título Original</a></li>
                                    <li><a href="../../indice/primeiro-verso-original">Prim. Verso Original</a></li>
                                    <li><a href="../../indice/metrica">Métrica</a></li>
                                </ul>
                            </li>
                            <li><a href="../../ajuda.html">Ajuda</a></li>
                            <li><a href="../../contato.html">Contato</a></li>
                        </ul>

                        <form action="../../pesquisa.html" class="navbar-form navbar-right" role="search">
                            <div class="form-group">
                                <input type="text" name="q" autocomplete="off" class="form-control" placeholder="Pesquisar por..." />
                                <input type='hidden' name='cx' value='007541164279382477135:v55cgb2k3be' />
                                <input type='hidden' name='cof' value='FORID:9' />
                                <input type='hidden' name='ie' value='UTF-8' />
                            </div>
                            <button type="submit" class="btn btn-default"><i class="fa fa-lg fa-search"></i></button>
                        </form>
                    </div>
                </div>
            </div>
        </nav>

        <div class="container">
            <div class="bs-docs-grid">
                <div class="row show-grid">
                    <div class="col-md-8">
                        <div class="panel panel-default">
                            <div class="panel-heading"><h1 class="panel-title"><xsl:value-of select='hino/numero'/> · <xsl:value-of select='hino/titulo'/> <span class="pull-right social"><a title="Compartilhe no Twitter" href="https://twitter.com/intent/tweet?text={hino/numero} · {hino/titulo}&amp;url=http://www.novocantico.com.br/hino/{hino/numero}/{hino/numero}.xml&amp;via=novo_cantico" target="_blank"><i class="fa fa-twitter fa-lg"></i></a> <a title="Compartilhe no Facebook" href="https://www.facebook.com/sharer/sharer.php?u=http://www.novocantico.com.br/hino/{hino/numero}/{hino/numero}.xml" target="_blank"><i class="fa fa-facebook-official fa-lg"></i></a></span></h1></div>

                            <div class="panel-body">
                                <xsl:choose>
                                <xsl:when test='hino/@situacao'>
                                </xsl:when>
                                <xsl:otherwise>
                                <a class="btn btn-primary pull-right" href="{hino/numero}.pdf" role="button">Mostrar partitura</a>
                                </xsl:otherwise>
                                </xsl:choose>

                                <ul id='texto' class="list-unstyled">
                                    <xsl:for-each select='hino/texto/estrofe'>
                                        <li class="estrofe">
                                            <ul class="list-unstyled">
                                            <xsl:for-each select='verso'>
                                                <li><xsl:if test='@voz'><span class='voz'>[<xsl:value-of select='./@voz'/>]</span>&#160;</xsl:if><xsl:value-of select='.'/></li>
                                            </xsl:for-each>
                                            </ul>

                                            <xsl:for-each select='coro'>
                                            <ul class='coro list-unstyled'>
                                                <xsl:if test='@voz'><li><span class='voz'>[<xsl:value-of select='./@voz'/>]</span></li></xsl:if>
                                                <xsl:for-each select='verso'>
                                                    <li><xsl:if test='@voz'><span class='voz'>[<xsl:value-of select='./@voz'/>]</span>&#160;</xsl:if><xsl:value-of select='.'/></li>
                                                </xsl:for-each>
                                            </ul>
                                            </xsl:for-each>
                                        </li>
                                    </xsl:for-each>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="panel panel-default">
                            <div class="panel-heading">Áudio</div>

                            <div class="panel-body">
                                <i class="fa fa-volume-up fa-5x pull-right"></i>
                                <xsl:choose>
                                <xsl:when test='hino/@situacao'>
                                <p>Não disponível</p>
                                </xsl:when>
                                <xsl:otherwise>
                                <form id="controle-audio">
                                    <div class="radio"><label><input type="radio" name="audio" data-id-audio="{hino/numero}" value="audio-todos" checked="checked" /> Todos</label></div>
                                    <div class="radio"><label><input type="radio" name="audio" data-id-audio="{hino/numero}s" value="audio-soprano" /> Soprano</label></div>
                                    <div class="radio"><label><input type="radio" name="audio" data-id-audio="{hino/numero}c" value="audio-contralto" /> Contralto</label></div>
                                    <div class="radio"><label><input type="radio" name="audio" data-id-audio="{hino/numero}t" value="audio-tenor" /> Tenor</label></div>
                                    <div class="radio"><label><input type="radio" name="audio" data-id-audio="{hino/numero}b" value="audio-baixo" /> Baixo</label></div>

                                    <div class="btn-group">
                                        <a id="btn-controle-audio" class="btn btn-primary"><i class="fa fa-play"></i> Reproduzir</a>
                                        <a class="btn btn-primary dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
                                            <span class="caret"></span>
                                            <span class="sr-only">Acionar menu de áudio</span>
                                        </a>
                                        <ul class="dropdown-menu" role="menu">
                                            <li><a href="{hino/numero}.mp3">Salvar</a></li>
                                        </ul>
                                    </div>
                                </form>

                                <audio id="audio-todos">
                                    <p>Seu navegador não permite a reprodução desse áudio.</p>
                                    <source src="./{hino/numero}.mp3" />
                                </audio>

                                <audio id="audio-soprano">
                                    <p>Seu navegador não permite a reprodução desse áudio.</p>
                                    <source src="./{hino/numero}s.mp3" />
                                </audio>

                                <audio id="audio-contralto">
                                    <p>Seu navegador não permite a reprodução desse áudio.</p>
                                    <source src="./{hino/numero}c.mp3" />
                                </audio>

                                <audio id="audio-tenor">
                                    <p>Seu navegador não permite a reprodução desse áudio.</p>
                                    <source src="./{hino/numero}t.mp3" />
                                </audio>

                                <audio id="audio-baixo">
                                    <p>Seu navegador não permite a reprodução desse áudio.</p>
                                    <source src="./{hino/numero}b.mp3" />
                                </audio>
                                </xsl:otherwise>
                                </xsl:choose>
                            </div>
                        </div>

                        <div class="panel panel-default">
                            <div class="panel-heading">Informação Adicional</div>

                            <div class="panel-body">
                                <i class="fa fa-info-circle fa-5x pull-right"></i>
                                <dl>
                                    <dt>Assunto</dt>
                                    <dd><a href='../../indice/assunto/index.html#{/hino/secao/@id}'><xsl:value-of select='hino/secao'/></a> &#8250; <a href='../../indice/assunto/index.html#{/hino/secao/@id}{/hino/assunto/@id}'><xsl:value-of select='hino/assunto'/></a></dd>

                                    <xsl:if test='hino/origem_letra'>
                                    <dt>Origem da Letra</dt>
                                    <xsl:for-each select='hino/origem_letra'>
                                    <dd><a href='../../indice/origem-letra/index.html#{./@id}'><xsl:value-of select='.'/></a><xsl:if test='./@ano'> (<xsl:value-of select='./@ano'/>)</xsl:if></dd>
                                    </xsl:for-each>
                                    </xsl:if>

                                    <xsl:if test='hino/origem_musica'>
                                    <dt>Origem da Música</dt>
                                    <xsl:for-each select='hino/origem_musica'>
                                    <dd><a href='../../indice/origem-musica/index.html#{./@id}'><xsl:value-of select='.'/></a><xsl:if test='./@ano'> (<xsl:value-of select='./@ano'/>)</xsl:if></dd>
                                    </xsl:for-each>
                                    </xsl:if>

                                    <xsl:if test='hino/referencia_biblica'>
                                    <dt>Referência Bíblica</dt>
                                    <xsl:for-each select='hino/referencia_biblica'>
                                    <dd><a href='../../indice/referencia-biblica/index.html#{./@id}'><xsl:value-of select='.'/></a></dd>
                                    </xsl:for-each>
                                    </xsl:if>

                                    <xsl:if test='hino/titulo_original'>
                                    <dt>Título Original</dt>
                                    <xsl:for-each select='hino/titulo_original'>
                                    <dd><a href='../../indice/titulo-original/index.html#{/hino/numero}'><xsl:value-of select='.'/></a></dd>
                                    </xsl:for-each>
                                    </xsl:if>

                                    <xsl:if test='hino/primeiro_verso_original'>
                                    <dt>1º Verso Original</dt>
                                    <xsl:for-each select='hino/primeiro_verso_original'>
                                    <dd><a href='../../indice/primeiro-verso-original/index.html#{/hino/numero}'><xsl:value-of select='.'/></a></dd>
                                    </xsl:for-each>
                                    </xsl:if>

                                    <xsl:if test='hino/metrica'>
                                    <dt>Métrica</dt>
                                    <xsl:for-each select='hino/metrica'>
                                    <dd><a href='../../indice/metrica/index.html#{/hino/metrica/@id}'><xsl:value-of select='.'/></a></dd>
                                    </xsl:for-each>
                                    </xsl:if>
                                </dl>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row show-grid">
                    <div class="col-md-12">
                        <p class="text-center">Entoai-lhe novo cântico, tangei com arte e com júbilo. Salmo 33.3</p>
                        <p class="text-center"><a href="https://twitter.com/novo_cantico" class="twitter-follow-button" data-show-count="false" data-lang="pt">Seguir @novo_cantico</a> <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script></p>
                    </div>
                </div>
            </div>
        </div>
        <script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>
        <script src="../../js/nc.js"></script>
    </body>
</html>
    </xsl:template>
</xsl:stylesheet>
