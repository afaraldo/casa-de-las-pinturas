var ProveedoresUI = (function(){
    return {
        initFormEvents: function(checkProveedorNombreUrl) {
            // Regla para validar que el nombre sea unico
            $.validator.addClassRules({
                uniqueProveedorNombre: {
                    remote: {
                        url: checkProveedorNombreUrl,
                        type: "get",
                        data: {
                            nombre: function() {
                                return $( "#proveedor_nombre" ).val();
                            },
                            id: function() {
                                return $('#proveedor_id').val();
                            }
                        }
                    }
                }
            });

            // Validate form
            $('#proveedor-form').validate();
        }
    };

}());