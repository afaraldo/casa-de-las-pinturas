var EmpleadosUI = (function(){
    return {
        initFormEvents: function(checkEmpleadoNombreUrl) {
            // Regla para validar que el nombre sea unico
            $.validator.addClassRules({
                uniqueEmpleadoNombre: {
                    remote: {
                        url: checkEmpleadoNombreUrl,
                        type: "get",
                        data: {
                            nombre: function() {
                                return $( "#empleado_nombre" ).val();
                            },
                            id: function() {
                                return $('#empleado_id').val();
                            }
                        }
                    }
                }
            });
            console.log('validation run');
            // Validate form
            $('#empleado-form').validate();
        }
    }
}());
