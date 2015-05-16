/*var astates = new Bloodhound({
  datumTokenizer: Bloodhound.tokenizers.whitespace,
  queryTokenizer: Bloodhound.tokenizers.whitespace,
  local: ['Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California',
  'Colorado', 'Connecticut', 'Delaware', 'Florida', 'Georgia', 'Hawaii',
  'Idaho', 'Illinois', 'Indiana', 'Iowa', 'Kansas', 'Kentucky', 'Louisiana',
  'Maine', 'Maryland', 'Massachusetts', 'Michigan', 'Minnesota',
  'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada', 'New Hampshire',
  'New Jersey', 'New Mexico', 'New York', 'North Carolina', 'North Dakota',
  'Ohio', 'Oklahoma', 'Oregon', 'Pennsylvania', 'Rhode Island',
  'South Carolina', 'South Dakota', 'Tennessee', 'Texas', 'Utah', 'Vermont',
  'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming']
});

$('.typeahead').typeahead({
  hint: true,
  highlight: true,
  minLength: 1
},
{
  name: 'states',
  source: astates
});*/

/*$.get( "../../arquivo.txt", function( data ) {
  alert( data );
});*/

String.prototype.fileExists = function() {
  filename = this.trim();

  alert(filename);

  var response = jQuery.ajax({
    url: filename,
    type: 'GET',
    async: false
  }).status;

  alert(response);

  return (response != "200") ? false : true;
}

function adicionarPagina(numeroHino, numeroPagina) {
  var url = numeroHino + "-" + numeroPagina + ".gif";

  if (url.fileExists()) {
    var pagina = $('<img src="' + url + '" class="img-responsive" />');
    pagina.appendTo("#modal-partitura .modal-body");

    numeroPagina += 1;
    if (numeroPagina < 4) {
      adicionarPagina(numeroHino, numeroPagina);
    }
  } else {
    return;
  }
}

$('.mostrar-partitura').click(function(e) {
  adicionarPagina($(this).attr('data-img-url'), 1);
});

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
  var audioElement = document.getElementById($("#controle-audio input[type='radio']:checked").val());

  toggleBtnControleAudio();

  if (!audioElement.paused && !audioElement.ended && 0 < audioElement.currentTime) {
    audioElement.pause();
    audioElement.currentTime = 0;
  } else {
    audioElement.play();
  }
});

