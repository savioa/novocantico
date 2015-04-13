<?php
    function obterRotulo($tipo, $numero)
    {
        $rotulos = json_decode(file_get_contents($tipo . '.json'), true);

        $iterador = new RecursiveIteratorIterator(new RecursiveArrayIterator($rotulos));
        foreach($iterador as $sub) {
            $subnivel = $iterador->getSubIterator();
            if($subnivel['numero'] == $numero) {
                return $subnivel['nome'];
            }
        }
    }
    
if(!empty($_POST['numero'])) {
    $xml = new SimpleXMLElement('<?xml version="1.0" encoding="UTF-8" ?><?xml-stylesheet type="text/xsl" href="../../hino.xsl"?><hino situacao="incompleto" />');

    $xml->numero = str_pad($_POST['numero'], 3, '0', STR_PAD_LEFT);
    $xml->n = ltrim($_POST['numero'], '0');
    $xml->titulo = $_POST['titulo'];

    $xml->secao = obterRotulo('secoes', $_POST['secao']);
    $xml->secao['id'] = str_pad($_POST['secao'], 2, '0', STR_PAD_LEFT);

    $xml->assunto = obterRotulo('assuntos', $_POST['assunto']);
    $xml->assunto['id'] = substr($_POST['assunto'], 1);

    $xml->metrica = $_POST['metrica'];
    $xml->metrica['id'] = str_replace('.', '_', $_POST['metrica']);

    if (!empty($_POST['tituloOriginal'])) {
        $xml->titulo_original = $_POST['tituloOriginal'];
    } else {
        $xml->titulo_original = $_POST['titulo'];
    }

    $texto = $xml->addChild('texto');
    $estrofe = $texto->addChild('estrofe');

    $conteudo = explode("\n", $_POST['texto']);
    foreach ($conteudo as $indice => $linha) {
        $linhaControle = trim($linha);
        if (empty($linhaControle)) {
            $estrofe = $texto->addChild('estrofe');
        } elseif ($linha[0] == "\t") {
            if (!isset($estrofe->coro)) {
                $coro = $estrofe->addChild('coro');
            }
            $estrofe->coro->addChild('verso', $linhaControle);
        } else {
            $estrofe->addChild('verso', $linhaControle);
        }
    }

    if (!empty($_POST['primeiroVersoOriginal'])) {
        $xml->primeiro_verso_original = $_POST['primeiroVersoOriginal'];
    } else {
        $xml->primeiro_verso_original = trim($conteudo[0]);
    }

    for ($i = 0; $i < 5; $i++) {
        $origem = $_POST["origemMusica_$i"];
        if (!empty($origem)) {
            if (strpos($origem, ';')) {
                $origem = explode(';', $origem);
                $nome = $origem[0];
                unset($origem[0]);
            } else {
                $nome = $origem;
            }
            $origemLetra = $xml->addChild('origem_musica', $nome);

            foreach ($origem as $indice => $valor) {
                $attr = explode('=', $valor);
                $origemLetra->addAttribute($attr[0], $attr[1]);
            }
        }
    }

    for ($i = 0; $i < 5; $i++) {
        $origem = $_POST["origemLetra_$i"];
        if (!empty($origem)) {
            if (strpos($origem, ';')) {
                $origem = explode(';', $origem);
                $nome = $origem[0];
                unset($origem[0]);
            } else {
                $nome = $origem;
            }
            $origemLetra = $xml->addChild('origem_letra', $nome);

            foreach ($origem as $indice => $valor) {
                $attr = explode('=', $valor);
                $origemLetra->addAttribute($attr[0], $attr[1]);
            }
        }
    }


    for ($i = 0; $i < 5; $i++) {
        $referencia['livro'] = $_POST["livro_$i"];
        $referencia['capitulo'] = $_POST["capitulo_$i"];
        $referencia['versiculo'] = $_POST["versiculo_$i"];

        if (!empty($referencia['capitulo'])) {
            $referencia_biblica = $xml->addChild('referencia_biblica', obterRotulo('livrosBiblicos', $referencia['livro']) . ' ' . $referencia['capitulo'] . '.' . $referencia['versiculo']);
            $referencia['livro'] = str_pad($referencia['livro'], 2, '0', STR_PAD_LEFT);
            $referencia['capitulo'] = str_pad($referencia['capitulo'], 3, '0', STR_PAD_LEFT);
            $referencia['versiculo'] = explode(',', $referencia['versiculo']);
            foreach ($referencia['versiculo'] as $indice => $versiculo) {
                $referencia['versiculo'][$indice] = str_pad($versiculo, 3, '0', STR_PAD_LEFT);
            }
            $referencia['versiculo'] = implode('_', $referencia['versiculo']);
            $referencia_biblica->addAttribute('id', str_replace(',', '_', trim(implode('_', $referencia), '_')));
        }
    }

    $dom = new DOMDocument('1.0');
    $dom->preserveWhiteSpace = false;
    $dom->formatOutput = true;
    $dom->loadXML($xml->asXML());
    $caminho = str_pad($_POST['numero'], 3, '0', STR_PAD_LEFT) . ".xml";
    echo $caminho;
    $dom->save($caminho);
    echo 'Wrote: ' . $dom->save("/home/a1612194/public_html/admin/$caminho") . ' bytes'; // Wrote: 72 bytes
    die();

}
?>
<!DOCTYPE html>
<html>
    <head>
        <title>Adicionar</title>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="css/bootstrap.min.css" rel="stylesheet" media="screen">
        <link href="css/base.css" rel="stylesheet" media="screen">
    </head>
    <body>
        <div class="container">
            <div class='page-header'>
                <h1>Novo Cântico <small>Administração</small></h1>
            </div>
            <form action='' method='POST' class='well'>
                <fieldset>
                    <legend>Adicionar Hino</legend>
                    <div class="row-fluid">
                        <div class="span6">
                            <label for="numero">Número</label>
                            <input type="text" class="input-mini" name="numero" id="numero" required />

                            <label for="secao">Seção</label>
                            <select name="secao" id="secao">
                                <option value="1">Louvor e Adoração</option>
                                <option value="2">Confissão</option>
                                <option value="3">Edificação</option>
                                <option value="4">Apelo</option>
                                <option value="5">Consagração</option>
                                <option value="6">Cristo - Sua vida</option>
                                <option value="7">Igreja - Seu Ministério</option>
                                <option value="8">Assuntos Diversos</option>
                                <option value="9">Outros</option>
                            </select>

                            <label for="assunto">Assunto</label>
                            <select name="assunto" id="assunto">
                                <option value="101">Intróitos</option>
                                <option value="102">Deus Trino</option>
                                <option value="103">Deus Santo</option>
                                <option value="104">Deus Soberano</option>
                                <option value="105">Deus Criador</option>
                                <option value="106">Deus Providente</option>
                                <option value="107">Deus Fiel</option>
                                <option value="108">Deus Senhor</option>
                                <option value="109">Deus Salvador</option>
                                <option value="110">Deus Vencedor</option>
                                <option value="111">Gratidão</option>
                                <option value="201">Contrição e Arrependimento</option>
                                <option value="202">Perdão</option>
                                <option value="301">Espírito Instruidor</option>
                                <option value="302">Espírito Consolador</option>
                                <option value="303">Espírito Vivificador</option>
                                <option value="304">Amor de Deus</option>
                                <option value="305">Fé</option>
                                <option value="306">Salvação</option>
                                <option value="307">Testemunho</option>
                                <option value="308">Companhia do Senhor</option>
                                <option value="309">Aspiração</option>
                                <option value="310">Oração</option>
                                <option value="311">Santificação</option>
                                <option value="312">Proteção</option>
                                <option value="313">Confiança</option>
                                <option value="314">Fidelidade</option>
                                <option value="315">Fraternidade</option>
                                <option value="316">Esperança</option>
                                <option value="317">Lar Celestial</option>
                                <option value="401">Convite</option>
                                <option value="402">Decisão</option>
                                <option value="501">Submissão</option>
                                <option value="502">Dedicação</option>
                                <option value="601">Advento</option>
                                <option value="602">Natal</option>
                                <option value="603">Ministério</option>
                                <option value="604">Entrada Triunfal</option>
                                <option value="605">Paixão e Morte</option>
                                <option value="606">Ressurreição</option>
                                <option value="607">Ascensão</option>
                                <option value="608">A Grande Comissão</option>
                                <option value="609">Segunda Vinda</option>
                                <option value="701">Igreja Militante</option>
                                <option value="702">Evangelização</option>
                                <option value="703">Trabalho Cristão</option>
                                <option value="704">Sociedade Auxiliadora Feminina</option>
                                <option value="705">União Presbiteriana de Homens</option>
                                <option value="706">Discipulado e Serviço</option>
                                <option value="707">Posse de Pastor</option>
                                <option value="708">Batismo</option>
                                <option value="709">Convertidos</option>
                                <option value="710">Profissão de Fé</option>
                                <option value="711">Ceia do Senhor</option>
                                <option value="712">Dia do Senhor</option>
                                <option value="713">Escola Dominical</option>
                                <option value="714">Crianças</option>
                                <option value="715">Despedida</option>
                                <option value="801">Bíblia</option>
                                <option value="802">Ano Novo</option>
                                <option value="803">Pátria</option>
                                <option value="804">Cidade</option>
                                <option value="805">Mocidade</option>
                                <option value="806">Casamento</option>
                                <option value="807">Lar Cristão</option>
                                <option value="808">Aniversário</option>
                                <option value="809">Mãe</option>
                                <option value="810">Final de Culto</option>
                            </select>

                            <label for="titulo">Título</label>
                            <input type="text" class="input-xlarge" name="titulo" id="titulo" required />

                            <label for="tituloOriginal">Título Original</label>
                            <input type="text" class="input-xlarge" name="tituloOriginal" id="tituloOriginal" />

                            <label for="primeiroVersoOriginal">Primeiro Verso Original</label>
                            <input type="text" class="input-xlarge" name="primeiroVersoOriginal" id="primeiroVersoOriginal" />

                            <label for="metrica">Métrica</label>
                            <input type="text" class="input-xlarge" name="metrica" id="metrica" required />

                            <label for="origemMusica_0">Origem da Música</label>
                            <input type="text" class="input-xlarge" name="origemMusica_0" id="origemMusica_0" /> <a tabindex="-1" title="Adicionar outra origem" class="origemMusica" href="#"><i class="icon-plus-sign"></i></a>

                            <label for="origemLetra_0">Origem da Letra</label>
                            <input type="text" class="input-xlarge" name="origemLetra_0" id="origemLetra_0" /> <a tabindex="-1" title="Adicionar outra origem" class="origemLetra" href="#"><i class="icon-plus-sign"></i></a>

                            <label for="livro_0">Referência Bíblica</label>
                            <div id="referencia_0">
                                <select class="input-mini" name="livro_0" id="livro_0">
                                    <option value="1">Gn</option>
                                    <option value="2">Êx</option>
                                    <option value="3">Lv</option>
                                    <option value="4">Nm</option>
                                    <option value="5">Dt</option>
                                    <option value="6">Js</option>
                                    <option value="7">Jz</option>
                                    <option value="8">Rt</option>
                                    <option value="9">1Sm</option>
                                    <option value="10">2Sm</option>
                                    <option value="11">1Rs</option>
                                    <option value="12">2Rs</option>
                                    <option value="13">1Cr</option>
                                    <option value="14">2Cr</option>
                                    <option value="15">Ed</option>
                                    <option value="16">Ne</option>
                                    <option value="17">Et</option>
                                    <option value="18">Jó</option>
                                    <option value="19">Sl</option>
                                    <option value="20">Pv</option>
                                    <option value="21">Ec</option>
                                    <option value="22">Ct</option>
                                    <option value="23">Is</option>
                                    <option value="24">Jr</option>
                                    <option value="25">Lm</option>
                                    <option value="26">Ez</option>
                                    <option value="27">Dn</option>
                                    <option value="28">Os</option>
                                    <option value="29">Jl</option>
                                    <option value="30">Am</option>
                                    <option value="31">Ob</option>
                                    <option value="32">Jn</option>
                                    <option value="33">Mq</option>
                                    <option value="34">Na</option>
                                    <option value="35">Hc</option>
                                    <option value="36">Sf</option>
                                    <option value="37">Ag</option>
                                    <option value="38">Zc</option>
                                    <option value="39">Ml</option>
                                    <option value="40">Mt</option>
                                    <option value="41">Mc</option>
                                    <option value="42">Lc</option>
                                    <option value="43">Jo</option>
                                    <option value="44">At</option>
                                    <option value="45">Rm</option>
                                    <option value="46">1Co</option>
                                    <option value="47">2Co</option>
                                    <option value="48">Gl</option>
                                    <option value="49">Ef</option>
                                    <option value="50">Fp</option>
                                    <option value="51">Cl</option>
                                    <option value="52">1Ts</option>
                                    <option value="53">2Ts</option>
                                    <option value="54">1Tn</option>
                                    <option value="55">2Tm</option>
                                    <option value="56">Tt</option>
                                    <option value="57">Fm</option>
                                    <option value="58">Hb</option>
                                    <option value="59">Tg</option>
                                    <option value="60">1Pe</option>
                                    <option value="61">2Pe</option>
                                    <option value="62">1Jo</option>
                                    <option value="63">2Jo</option>
                                    <option value="64">3Jo</option>
                                    <option value="65">Jd</option>
                                    <option value="66">Ap</option>
                                </select>
                                <input type="number" class="input-mini" name="capitulo_0" placeholder="Capítulo" />
                                <input type="text" class="input-mini" name="versiculo_0" placeholder="Versículo" /> <a title="Adicionar outra referência" class="referencia" href="#"><i class="icon-plus-sign"></i></a>
                            </div>
                        </div>

                        <div class="span6">
                            <label for="texto">Texto</label>
                            <textarea rows="25" name="texto" id="texto" required class="span12"></textarea>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">Salvar</button>
                        <button type="button" onclick="history.go(-1)" class="btn">Cancelar</button>
                    </div>
                </fieldset>
            </form>
        </div>
        <script src="js/jquery-2.0.2.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <script type="text/javascript">
                            $(document).ready(function() {
                                $("#texto").on('keydown', function(e) {
                                    if (e.which === 9 && e.shiftKey) {
                                        e.preventDefault();
                                        var start = $(this).get(0).selectionStart;
                                        var end = $(this).get(0).selectionEnd;

                                        // set textarea value to: text before caret + tab + text after caret
                                        $(this).val($(this).val().substring(0, start) + "\t" + $(this).val().substring(end));

                                        // put caret at right position again
                                        $(this).get(0).selectionStart = $(this).get(0).selectionEnd = start + 1;
                                    }
                                });

                                $("#secao").change(function() {
                                    $("#assunto").val($(this).val() + "01");
                                });

                                $("#assunto").change(function() {
                                    $("#secao").val($(this).val().substring(0, 1));
                                });

                                $("a > i.icon-plus-sign").parent().click(function() {
                                    var $classe = $(this).attr('class');
                                    var $referencia = $('#' + $classe + '_0').clone();

                                    if ($(this).hasClass('origemMusica') || $(this).hasClass('origemLetra')) {
                                        $($referencia).val("").end();
                                        $('#' + $classe + '_0 ~ a').first().after($referencia);

                                        $('input[name^="' + $(this).attr('class') + '_"]').each(function(index) {
                                            $(this).attr('name', $classe + '_' + index);
                                            $(this).attr('id', $classe + '_' + index);
                                        });

                                        $('#' + $classe + '_0 ~ input').first().focus().after(' <a tabindex="-1" class="' + $classe + '" title="Excluir este item" href="#"><i class="icon-minus-sign"></i></a>');

                                        $("a." + $classe + " > i.icon-minus-sign").parent().click(function() {
                                            $(this).prev().remove();
                                            $(this).remove();
                                        });
                                    } else {
                                        $referencia.find('input').val("").end();
                                        $referencia.find('a i').attr('class', 'icon-minus-sign').end();
                                        $('#' + $classe + '_0').after($referencia);
                                        $referencia.find('select').focus()

                                        $('select[name^="livro_"]').each(function(index) {
                                            $(this).parent().attr('id', $classe + '_' + index);
                                            $(this).attr('name', 'livro_' + index).attr('id', 'livro_' + index);
                                            $(this).siblings('[name^="capitulo_"]').attr('name', 'capitulo_' + index).attr('id', 'capitulo_' + index);
                                            $(this).siblings('[name^="versiculo_"]').attr('name', 'versiculo_' + index).attr('id', 'versiculo_' + index);
                                        });

                                        $("a." + $classe + " > i.icon-minus-sign").parent().click(function() {
                                            $(this).parent().remove();
                                        }).attr('title', 'Excluir este item');
                                    }
                                });
                            });
        </script>
    </body>
</html>