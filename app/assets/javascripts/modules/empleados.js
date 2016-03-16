var EmpleadosUI = (function(){
    return {
        initFormEvents: function() {
            console.log('validation run');
            // Validate form
            $('#empleado-form').validate();
        }
    };

}());
