var ClientesUI = (function(){
    return {
        initFormEvents: function(checkClienteNombreUrl) {
            // Regla para validar que el nombre sea unico
            $.validator.addClassRules({
                uniqueClienteNombre: {
                    remote: {
                        url: checkClienteNombreUrl,
                        type: "get",
                        data: {
                            nombre: function() {
                                return $( "#cliente_nombre" ).val();
                            },
                            id: function() {
                                return $('#cliente_id').val();
                            }
                        }
                    }
                }
            });

            NumberHelper.mascaraMoneda('.maskMoneda');

            // Validate form
            $('#cliente-form').validate();
        }
    };

}());