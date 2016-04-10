var CategoriaGastosUI = (function(){
    return {
        initFormEvents: function(checkCategoriaGastoNombreUrl) {
            // Regla para validar que el nombre sea unico
            $.validator.addClassRules({
                uniqueCategoriaGastoNombre: {
                    remote: {
                        url: checkCategoriaGastoNombreUrl,
                        type: "get",
                        data: {
                            nombre: function() {
                                return $( "#categoria_gasto_nombre" ).val();
                            },
                            id: function() {
                                return $('#categoria_gasto_id').val();
                            }
                        }
                    }
                }
            });

            // Validate form
            $('#categoria_gasto-form').validate();
            // Auto focus
            $('.modal').on('shown.bs.modal', function() {
              $(this).find('[autofocus]').focus();
            });
        }
    };

}());