function toggleBtnControleAudio() {
  var btn = $('#btn-controle-audio');
  if(btn.children('i').attr('class') == 'fa fa-play') {
    btn.children('i').attr('class', 'fa fa-pause');
    btn.contents().last().replaceWith(" Interromper");
  } else {
    btn.children('i').attr('class', 'fa fa-play');
    btn.contents().last().replaceWith(" Reproduzir");
  }
}

function obterParametroUrl(nomeParametro)
{
    var sPageURL = window.location.search.substring(1);
    var sURLVariables = sPageURL.split('&');
    for (var i = 0; i < sURLVariables.length; i++)
    {
        var sParameterName = sURLVariables[i].split('=');
        if (sParameterName[0] == nomeParametro)
        {
            return sParameterName[1];
        }
    }
}

var valorParametroPesquisa = obterParametroUrl("q");
if(valorParametroPesquisa != undefined)
{
  if (valorParametroPesquisa == '110')
  {
    window.location.href = "https://novocantico.com.br/hino/" + valorParametroPesquisa + "/" + valorParametroPesquisa + ".xml";
  }

  $('input[name="q"]').focus();
  $('input[name="q"]').val(valorParametroPesquisa);
}

$("#controle-audio input[type='radio']").click(function(e) {
  var audios = document.getElementsByTagName('audio'), i;
  for (i = 0; i < audios.length; ++i) {
    if (!audios[i].paused && !audios[i].ended && 0 < audios[i].currentTime) {
      audios[i].pause();
      audios[i].currentTime = 0;

      toggleBtnControleAudio();
    }
  }

  $("#controle-audio li a").attr("href", $(this).attr("data-id-audio") + ".mp3");
});

$('#btn-controle-audio').click(function(e) {
  toggleBtnControleAudio();

  var audioElement = document.getElementById($("#controle-audio input[type='radio']:checked").val());

  if (!audioElement.paused && !audioElement.ended && 0 < audioElement.currentTime) {
    audioElement.pause();
    audioElement.currentTime = 0;
  } else {
    audioElement.play();

    audioElement.onended = function() {
      toggleBtnControleAudio();
    };
  }
});

$(function() {
    var $affixElement = $('div[data-spy="affix"]');
    $affixElement.width($affixElement.parent().width());
});

$( window ).resize(function() {
    var $affixElement = $('div[data-spy="affix"]');
    $affixElement.width($affixElement.parent().width());
});