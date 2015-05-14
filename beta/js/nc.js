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

$('.mostrarPartitura').click(function(e) {
    $('#myModal img').attr('src', $(this).attr('data-img-url'));
});

$('#btn-controle-audio button').click(function(e) {
  var audioElement = document.getElementById($(this).attr("data-id-audio"));

if (!audioElement.paused && !audioElement.ended && 0 < audioElement.currentTime)
  {
    audioElement.pause();
    $(this).html("<i class='fa fa-play'></i> " + $(this).text());
  }
  else
  {
    audioElement.play();
    $(this).html("<i class='fa fa-pause'></i> " + $(this).text());
  }
});

/*
$('#botao-tocar').click(function(e) {
  
});
*/