var DatepickerHelper = {
    // Funcion para inicializar un datepicker simple a partir de un selector
    initDatepicker: function(selector) {
        $(selector).datepicker();

        // Evento para el boton al lado del campo datepicker
        $(selector + ' + .input-group-btn').on('click', function(e){
            $(this).siblings('.datepicker').datepicker('show');
        });
    }
};