<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform' xmlns:nc='http://www.novocantico.com.br/schema/hino'>
    <xsl:output method='html' encoding='utf-8' indent='no' />
    <xsl:template match='/'>
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
<html lang='pt-br'>

<head>
    <meta http-equiv='X-UA-Compatible' content='IE=edge' />
    <meta name='viewport' content='width=device-width, initial-scale=1' />
    <title><xsl:value-of select='nc:hino/@num' /> · <xsl:value-of select='nc:hino/@tit' /> · Novo Cântico</title>
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
                            <h1 class='panel-title'><xsl:value-of select='nc:hino/@num' /> · <xsl:value-of select='nc:hino/@tit' /> <span class='pull-right social'><a title='Compartilhe no Twitter' href='https://twitter.com/intent/tweet?text={nc:hino/@num}%20·%20{nc:hino/@tit}&amp;url=http://www.novocantico.com.br/hino/{nc:hino/@num}/{nc:hino/@num}.xml&amp;via=novo_cantico' target='_blank'><i class='fa fa-twitter fa-lg'></i></a> <a title='Compartilhe no Facebook' href='https://www.facebook.com/sharer/sharer.php?u=http://www.novocantico.com.br/hino/{nc:hino/@num}/{nc:hino/@num}.xml' target='_blank'><i class='fa fa-facebook-official fa-lg'></i></a></span></h1>
                            <xsl:if test='nc:hino/@tit_ant'>
                            <div class='panel-heading'><xsl:value-of select='nc:hino/@tit_ant' /></div>
                            </xsl:if>
                        </div>

                        <div class='panel-body'>
                            <xsl:choose>
                            <xsl:when test='nc:hino/@situacao'>
                            </xsl:when>
                            <xsl:otherwise>
                            <a class='btn btn-primary pull-right' href='{nc:hino/@num}.pdf' role='button'>Mostrar partitura</a>
                            </xsl:otherwise>
                            </xsl:choose>

                            <ul id='texto' class='list-unstyled'>
                                <xsl:for-each select='nc:hino/nc:tex/nc:est'>
                                <li class='estrofe'>
                                    <ul class='list-unstyled'>
                                        <xsl:for-each select='nc:ver'>
                                        <li><xsl:if test='@voz'><span class='voz'>[<xsl:value-of select='./@voz' />]</span>&#160;</xsl:if><xsl:value-of select='.' /></li>
                                        </xsl:for-each>
                                    </ul>

                                    <xsl:for-each select='nc:cor'>
                                    <ul class='coro list-unstyled'>
                                        <xsl:if test='@voz'><li><span class='voz'>[<xsl:value-of select='./@voz' />]</span></li></xsl:if>
                                        <xsl:for-each select='nc:ver'>
                                        <li><xsl:if test='@voz'><span class='voz'>[<xsl:value-of select='./@voz' />]</span>&#160;</xsl:if><xsl:value-of select='.' /></li>
                                        </xsl:for-each>
                                    </ul>
                                    </xsl:for-each>
                                </li>
                                </xsl:for-each>
                            </ul>
                        </div>
                    </div>
                </div>

                <div class='col-md-4'>
                    <div class='panel panel-default'>
                        <div class='panel-heading'>Áudio</div>

                        <div class='panel-body'>
                            <i class='fa fa-volume-up fa-5x pull-right'></i>
                            <xsl:choose>
                            <xsl:when test='nc:hino/@situacao'>
                            <p>Não disponível</p>
                            </xsl:when>
                            <xsl:otherwise>
                            <form id='controle-audio'>
                                <div class='radio'><label><input type='radio' name='audio' data-id-audio='https://archive.org/download/impessoal_elleralmeida_{nc:hino/@num}/{nc:hino/@num}' value='audio-todos' checked='checked' /> Todos</label></div>
                                <div class='radio'><label><input type='radio' name='audio' data-id-audio='https://archive.org/download/impessoal_elleralmeida_{nc:hino/@num}/{nc:hino/@num}s' value='audio-soprano' /> Soprano</label></div>
                                <div class='radio'><label><input type='radio' name='audio' data-id-audio='https://archive.org/download/impessoal_elleralmeida_{nc:hino/@num}/{nc:hino/@num}c' value='audio-contralto' /> Contralto</label></div>
                                <div class='radio'><label><input type='radio' name='audio' data-id-audio='https://archive.org/download/impessoal_elleralmeida_{nc:hino/@num}/{nc:hino/@num}t' value='audio-tenor' /> Tenor</label></div>
                                <div class='radio'><label><input type='radio' name='audio' data-id-audio='https://archive.org/download/impessoal_elleralmeida_{nc:hino/@num}/{nc:hino/@num}b' value='audio-baixo' /> Baixo</label></div>

                                <div class='btn-group'>
                                    <a id='btn-controle-audio' class='btn btn-primary'><i class='fa fa-play'></i> Reproduzir</a>
                                    <a href='#' class='btn btn-primary dropdown-toggle' data-toggle='dropdown' role='button' aria-expanded='false'>
                                        <span class='caret'></span>
                                        <span class='sr-only'>Acionar menu de áudio</span>
                                    </a>
                                    <ul class='dropdown-menu' role='menu'>
                                        <li><a href='https://archive.org/download/impessoal_elleralmeida_{nc:hino/@num}/{nc:hino/@num}.mp3'>Salvar</a></li>
                                    </ul>
                                </div>
                            </form>

                            <audio id='audio-todos' src='https://archive.org/download/impessoal_elleralmeida_{nc:hino/@num}/{nc:hino/@num}.mp3'>
                                <p>Seu navegador não permite a reprodução desse áudio.</p>
                            </audio>

                            <audio id='audio-soprano' src='https://archive.org/download/impessoal_elleralmeida_{nc:hino/@num}/{nc:hino/@num}s.mp3'>
                                <p>Seu navegador não permite a reprodução desse áudio.</p>
                            </audio>

                            <audio id='audio-contralto'  src='https://archive.org/download/impessoal_elleralmeida_{nc:hino/@num}/{nc:hino/@num}c.mp3'>
                                <p>Seu navegador não permite a reprodução desse áudio.</p>
                            </audio>

                            <audio id='audio-tenor' src='https://archive.org/download/impessoal_elleralmeida_{nc:hino/@num}/{nc:hino/@num}t.mp3'>
                                <p>Seu navegador não permite a reprodução desse áudio.</p>
                            </audio>

                            <audio id='audio-baixo' src='https://archive.org/download/impessoal_elleralmeida_{nc:hino/@num}/{nc:hino/@num}b.mp3'>
                                <p>Seu navegador não permite a reprodução desse áudio.</p>
                            </audio>
                            </xsl:otherwise>
                            </xsl:choose>
                        </div>
                    </div>

                    <div class='panel panel-default'>
                        <div class='panel-heading'>Informação Adicional</div>

                        <div class='panel-body'>
                            <i class='fa fa-info-circle fa-5x pull-right'></i>
                            <dl>
                                <dt>Assunto</dt>
                                <dd><a href='../assunto#{substring(/nc:hino/@sec, 1, 2)}'><xsl:value-of select='translate(substring(nc:hino/@sec, 4), "_", " ")' /></a> &#8250; <a href='../assunto#{substring(/nc:hino/@ass, 1, 5)}'><xsl:value-of select='translate(substring(nc:hino/@ass, 7), "_", " ")' /></a></dd>

                                <xsl:if test='nc:hino/nc:ori_let'>
                                <dt>Origem da Letra</dt>
                                <xsl:for-each select='nc:hino/nc:ori_let'>
                                <dd><a href='../origem-letra#{./@id}'><xsl:value-of select='./@id' /></a><xsl:if test='./@ano'> (<xsl:value-of select='./@ano' />)</xsl:if></dd>
                                </xsl:for-each>
                                </xsl:if>

                                <xsl:if test='nc:hino/nc:ori_mus'>
                                <dt>Origem da Música</dt>
                                <xsl:for-each select='nc:hino/nc:ori_mus'>
                                <dd><a href='../origem-musica#{./@id}'><xsl:value-of select='./@id' /></a><xsl:if test='./@ano'> (<xsl:value-of select='./@ano' />)</xsl:if></dd>
                                </xsl:for-each>
                                </xsl:if>

                                <xsl:if test='nc:hino/nc:ref_bib'>
                                <dt>Referência Bíblica</dt>
                                <xsl:for-each select='nc:hino/nc:ref_bib'>
                                <dd><a href='../referencia-biblica#{./@liv}_{./@cap}_{./@ver}'><xsl:value-of select='./@liv' />#<xsl:value-of select='./@cap' />.<xsl:value-of select='./@ver' /></a></dd>
                                </xsl:for-each>
                                </xsl:if>

                                <xsl:if test='nc:hino/nc:tit_ori'>
                                <dt>Título Original</dt>
                                <xsl:for-each select='nc:hino/nc:tit_ori'>
                                <dd><a href='../titulo-original#{/nc:hino/@num}'><xsl:value-of select='.' /></a></dd>
                                </xsl:for-each>
                                </xsl:if>

                                <xsl:if test='nc:hino/nc:pri_ver_ori'>
                                <dt>1º Verso Original</dt>
                                <xsl:for-each select='nc:hino/nc:pri_ver_ori'>
                                <dd><a href='../primeiro-verso-original#{/nc:hino/@num}'><xsl:value-of select='.' /></a></dd>
                                </xsl:for-each>
                                </xsl:if>

                                <xsl:if test='nc:hino/@met'>
                                <dt>Métrica</dt>
                                <xsl:for-each select='nc:hino/@met'>
                                <dd><a href='../metrica#{/nc:hino/@met}'><xsl:value-of select='.' /></a></dd>
                                </xsl:for-each>
                                </xsl:if>
                            </dl>
                        </div>
                    </div>
                </div>
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