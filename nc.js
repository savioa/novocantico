$(document)
  .ready(function() {

    var
      changeSides = function() {
        $('.ui.shape')
          .eq(0)
            .shape('flip over')
            .end()
          .eq(1)
            .shape('flip over')
            .end()
          .eq(2)
            .shape('flip back')
            .end()
          .eq(3)
            .shape('flip back')
            .end()
        ;
      },
      validationRules = {
        firstName: {
          identifier  : 'email',
          rules: [
            {
              type   : 'empty',
              prompt : 'Please enter an e-mail'
            },
            {
              type   : 'email',
              prompt : 'Please enter a valid e-mail'
            }
          ]
        }
      }
    ;

    $('.ui.dropdown')
      .dropdown({
        on: 'hover'
      })
    ;

    $('.ui.form')
      .form(validationRules, {
        on: 'blur'
      })
    ;

    $('.masthead .information')
      .transition('scale in', 1000)
    ;

    $('.ui.search')
      .search({
        source: content
      })
    ;

    var content = [
      { title: 'Andorra' },
      { title: 'United Arab Emirates' },
      { title: 'Afghanistan' },
      { title: 'Antigua' },
      { title: 'Anguilla' },
      { title: 'Albania' },
      { title: 'Armenia' },
      { title: 'Netherlands Antilles' },
      { title: 'Angola' },
      { title: 'Argentina' },
      { title: 'American Samoa' },
      { title: 'Austria' },
      { title: 'Australia' },
      { title: 'Aruba' },
      { title: 'Aland Islands' },
      { title: 'Azerbaijan' },
      { title: 'Bosnia' },
      { title: 'Barbados' },
      { title: 'Bangladesh' },
      { title: 'Belgium' },
      { title: 'Burkina Faso' },
      { title: 'Bulgaria' },
      { title: 'Bahrain' },
      { title: 'Burundi' }
      // etc
    ];

    setInterval(changeSides, 3000);

  })
;