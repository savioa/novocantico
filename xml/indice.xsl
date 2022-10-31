<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>
    <xsl:output method='html' encoding='utf-8' indent='yes' />
    <xsl:template match='/'>
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
<html lang='pt-br'>

<head>
    <meta http-equiv='X-UA-Compatible' content='IE=edge' />
    <meta name='viewport' content='width=device-width, initial-scale=1' />
    <title>Índice por <xsl:value-of select='indice/@nome' /> · Novo Cântico</title>
    <link href='https://maxcdn.bootstrapcdn.com/bootswatch/3.3.4/cosmo/bootstrap.min.css' rel='stylesheet' />
    <link href='http://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css' rel='stylesheet' />
    <link href='../css/nc.css' rel='stylesheet' />
</head>

<body>
    <nav class='navbar navbar-inverse navbar-static-top'>
        <div class='container'>
            <div class='container-fluid'>
                <div class='navbar-header'>
                    <button type='button' class='navbar-toggle collapsed' data-toggle='collapse' data-target='#bs-example-navbar-collapse-2'>
                        <span class='sr-only'>Acionar menu de navegação</span>
                        <span class='icon-bar'></span>
                        <span class='icon-bar'></span>
                        <span class='icon-bar'></span>
                    </button>
                    <a class='navbar-brand' href='../'>Novo Cântico</a>
                </div>

                <div class='collapse navbar-collapse' id='bs-example-navbar-collapse-2'>
                    <ul class='nav navbar-nav'>
                        <li class='dropdown'>
                            <a href='#' class='dropdown-toggle' data-toggle='dropdown' role='button' aria-expanded='false'>Índices <span class='caret'></span></a>
                            <ul class='dropdown-menu' role='menu'>
                                <li><a href='../assunto'>Número/Assunto</a></li>
                                <li><a href='../primeiro-verso'>Primeiro Verso</a></li>
                                <li><a href='../coro'>Coro</a></li>
                                <li class='divider'></li>
                                <li><a href='../origem-letra'>Origem da Letra</a></li>
                                <li><a href='../origem-musica'>Origem da Música</a></li>
                                <li><a href='../referencia-biblica'>Referência Bíblica</a></li>
                                <li><a href='../titulo-original'>Título Original</a></li>
                                <li><a href='../primeiro-verso-original'>Prim. Verso Original</a></li>
                                <li><a href='../metrica'>Métrica</a></li>
                            </ul>
                        </li>
                        <li><a href='../ajuda'>Ajuda</a></li>
                    </ul>

                    <form action='../pesquisa' class='navbar-form navbar-right' role='search'>
                        <div class='form-group'>
                            <input type='text' name='q' autocomplete='off' class='form-control' placeholder='Pesquisar por...' />
                            <input type='hidden' name='cx' value='007541164279382477135:v55cgb2k3be' />
                            <input type='hidden' name='cof' value='FORID:9' />
                            <input type='hidden' name='ie' value='UTF-8' />
                        </div>
                        <button type='submit' class='btn btn-default'><i class='fa fa-lg fa-search'></i></button>
                    </form>
                </div>
            </div>
        </div>
    </nav>

    <div class='container'>
        <div class='bs-docs-grid'>
            <div class='row show-grid'>
                <div class='col-md-8'>
                    <div class='panel panel-default'>
                        <div class='panel-heading'>
                            <h1 class='panel-title'>Índice por <xsl:value-of select='indice/@nome' /></h1>
                        </div>

                        <div class='panel-body'>
                            <xsl:if test='indice/@nome != "Métrica" and indice/@nome != "Assunto"'>
                            <ul id='navegacao-movel' class='nav nav-pills hidden-lg hidden-md'>
                                <xsl:for-each select='indice/grupo'>
                                    <xsl:variable name='idGrupo' select='./@valor' />
                                    <xsl:variable name='descricao'>
                                        <xsl:choose>
                                            <xsl:when test='/indice/@nome !="Referência Bíblica"'>
                                                <xsl:value-of select='./@descricao' />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select='./@valor' />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                <li role='presentation'><a href='#{$idGrupo}'><xsl:value-of select='$descricao' /></a></li>
                                </xsl:for-each>
                            </ul>
                            </xsl:if>

                            <ul class='list-unstyled indice'>
                                <xsl:for-each select='indice/grupo'>
                                    <xsl:variable name='idGrupo' select='./@valor' />
                                    <li id='{$idGrupo}'><h2><xsl:value-of select='./@descricao' /></h2> <xsl:if test='/indice/@nome != "Métrica" and /indice/@nome != "Assunto"'><a class='hidden-lg hidden-md' title='Ir para o topo' href='#navegacao-movel'><i class='fa fa-level-up'></i></a></xsl:if>
                                        <ul class='list-unstyled'>
                                            <xsl:choose>
                                                <xsl:when test='/indice/@nome != "Assunto"'>
                                                    <xsl:for-each select='./termo'>
                                                        <xsl:choose>
                                                            <xsl:when test='./@descricao'>
                                                                <xsl:variable name='idTermo' select='./@valor' />
                                            <li id='{$idTermo}'><xsl:value-of select='./@descricao' />: <xsl:for-each select='./ocorrencia'>
                                                <xsl:variable name='numero' select='./@valor' />
                                                <xsl:variable name='titulo' select='./@descricao' />
                                                <a href='../{$numero}' title='{$titulo}'><xsl:value-of select='./@valor' /></a>, </xsl:for-each></li>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:variable name='numeroTermo' select='./ocorrencia[1]/@valor' />
                                            <li id='{$numeroTermo}'><xsl:value-of select='./@valor' />: <xsl:for-each select='./ocorrencia'>
                                                <xsl:variable name='numero' select='./@valor' />
                                                <xsl:variable name='titulo' select='./@descricao' />
                                                <a href='../{$numero}' title='{$titulo}'><xsl:value-of select='./@valor' /></a>, </xsl:for-each></li>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:for-each>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:for-each select='./termo'>
                                                        <xsl:variable name='numeroTermo' select='./@valor' />
                                            <li id='{$numeroTermo}'>
                                                <h3><xsl:value-of select='./@descricao' /></h3>
                                                <ul class='list-unstyled'>
                                                    <xsl:for-each select='./ocorrencia'>
                                                        <xsl:variable name='numero' select='./@valor' />
                                                    <li>
                                                        <a href='../{$numero}'><xsl:value-of select='./@valor' /> · <xsl:value-of select='./@descricao' /></a>
                                                        <xsl:if test='./@tituloAnterior'> · <i><xsl:value-of select='./@tituloAnterior' /></i></xsl:if>
                                                    </li>
                                                    </xsl:for-each>
                                                </ul>
                                            </li>        
                                                    </xsl:for-each>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </ul>
                                    </li>
                                </xsl:for-each>
                            </ul>
                        </div>
                    </div>
                </div>

                <xsl:if test='/indice/@nome != "Métrica" and /indice/@nome != "Assunto"'>
                <div class='col-md-4'>
                    <div id='navegacao' class='panel panel-default hidden-xs hidden-sm' data-spy='affix' data-offset='85'>
                        <ul class='nav nav-pills'>
                            <xsl:for-each select='/indice/grupo'>
                            <xsl:variable name='idGrupo' select='./@valor' />
                            <xsl:variable name='descricao'>
                                <xsl:choose>
                                    <xsl:when test='/indice/@nome !="Referência Bíblica"'>
                                        <xsl:value-of select='./@descricao' />
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select='./@valor' />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <li role='presentation'><a href='#{$idGrupo}'><xsl:value-of select='$descricao' /></a></li>
                            </xsl:for-each>
                        </ul>
                    </div>
                </div>
                </xsl:if>
            </div>

            <div class='row show-grid'>
                <div class='col-md-12'>
                    <p class='text-center'>Entoai-lhe novo cântico, tangei com arte e com júbilo. Salmo 33.3</p>
                    <p class='text-center'><a href='https://twitter.com/novo_cantico' class='twitter-follow-button' data-show-count='false' data-lang='pt'>Seguir @novo_cantico</a> <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script></p>
                </div>
            </div>
        </div>
    </div>
    <script src='http://code.jquery.com/jquery-2.1.4.min.js'></script>
    <script src='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js'></script>
    <script src='../js/nc.js'></script>
</body>

</html>
    </xsl:template>
</xsl:stylesheet>
