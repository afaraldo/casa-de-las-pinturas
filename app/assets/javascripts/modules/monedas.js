var MonedasUI = (function(){
    return {
        initFormEvents: function(checkMonedaNombreUrl) {
          // Regla para validar que el nombre sea unico
          $.validator.addClassRules({
              uniqueMonedaNombre: {
                  remote: {
                      url: checkMonedaNombreUrl,
                      type: "get",
                      data: {
                          nombre: function() {
                              return $( "#moneda_nombre" ).val();
                          },
                          id: function() {
                              return $('#moneda_id').val();
                          }
                      }
                  }
              }
          });

          NumberHelper.mascaraMoneda('.maskMoneda');

          // Validate form
          $('#moneda-form').validate();
      }
  };

}());
