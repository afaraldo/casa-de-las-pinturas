var CategoriasUI = (function(){
    return {
        initFormEvents: function(checkCategoriaNombreUrl) {
            // Regla para validar que el nombre sea unico
            $.validator.addClassRules({
                uniqueCategoriaNombre: {
                    remote: {
                        url: checkCategoriaNombreUrl,
                        type: "get",
                        data: {
                            nombre: function() {
                                return $( "#categoria_nombre" ).val();
                            },
                            id: function() {
                                return $('#categoria_id').val();
                            }
                        }
                    }
                }
            });

            // Validate form
            var form = $('#categoria-form');
            form.validate();
        }
    };

}());