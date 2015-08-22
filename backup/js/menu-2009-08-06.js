$(document).ready(function() {
	if ($('#indice_dinamico ul')) {
		$('#indice_dinamico li a[href=""]').click(
			function() {
				if ($(this).children('span:first-child').html() == '+') {
					$(this).children('span:first-child').html('-');
				} else {
					$(this).children('span:first-child').html('+');
				}
				$(this).next().toggle();
				return false;
			}
		);

		$('.expandir').click(
			function() {
				if ($(this).html() == 'Expandir tudo') {
					$('.expandir').html('Contrair tudo')
					$('#indice_dinamico ul').show();
					$('#indice_dinamico span').html('-');

				} else {
					$('.expandir').html('Expandir tudo')
					$('#indice_dinamico ul').hide();
					$('#indice_dinamico span').html('+');
				}
				return false;
			}
		);
	}

	$('a[href="#conteudo"]').click(
		function() {
			var posicaoLasanha = window.location.toString().indexOf('#');
			if (posicaoLasanha > 0) {
				var url = window.location.toString();
				var id = url.substr(posicaoLasanha);
				if (id != '#conteudo') {
					$(id).css('background-color', 'transparent');
				}
			}
		}
	);

	$('#navegacao_alfa a').click(
		function() {
			var posicaoLasanha = window.location.toString().indexOf('#');
			if (posicaoLasanha > 0) {
				var url = window.location.toString();
				var id = url.substr(posicaoLasanha);
				if (id != '#conteudo') {
					$(id).css('background-color', 'transparent');
				}
			}


			var id = $(this).attr('href');
			$(id).css('background-color', 'yellow');
		}
	);

	// ASSUNTO
	if (window.location.toString().indexOf('assunto') >= 0) {
	  var posicaoLasanha = window.location.toString().indexOf('#');
	  if (posicaoLasanha > 0) {
	    var url = window.location.toString();
	    var secao = url.substr(posicaoLasanha + 1, 2);
			var completo = url.substr(posicaoLasanha + 1);
			$("a[name=" + completo + "]").css('background-color', 'yellow');
	
	    if (secao.length) {
	      $('a[name=' + secao + ']').next().toggle();
	
	      var assunto = url.substr(posicaoLasanha + 3, 2);
	      if (assunto.length) {
	        $('a[name=' + secao + assunto + ']').next().toggle();
	      }
	    }
	  }
	}
	// OUTROS INDICES
	else {
		var posicaoLasanha = window.location.toString().indexOf('#');
		if (posicaoLasanha > 0) {
		   	var url = window.location.toString();
			var id = url.substr(posicaoLasanha + 1);
			if (id != 'conteudo') {
				$("#" + id).css('background-color', 'yellow');
			}
		}
	}
});