$(document)
.ready(function() {

  $('.ui.dropdown')
  .dropdown()
  ;

  var content = [
  {
    title: '1',
    description: 'Justo é o Senhor em seus santos caminhos'
  },
  {
    title: '12',
    description: 'O Senhor está no seu santo templo'
  }
  ];

  $('.ui.search').search({
    type: 'standard',
    source : content,
    searchFields   : [
    'title'
    ],
    searchFullText: true
  });
});