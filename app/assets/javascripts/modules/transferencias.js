var TransferenciasUI = (function(){
    var elementos = null;

    function calcularTotal(){
        $('#caja-movimiento-detalles-body').find('.cantidad').trigger('change');
    }

    function initFormEvents(){
        $('#caja-movimiento-form').validate({ignore: []}); // validar formulario. ignore: [] es para que valide campos no visibles tambien

        NumberHelper.mascaraMoneda('.maskMoneda');

        DatepickerHelper.initDatepicker('.datepicker');
    }

    return {
        init: function() {
            elementos = {
                movimientoForm: $('#caja-movimiento-form')
            }
        },
        'new': function() {
            initFormEvents();
        },
        'create': function(){
            initFormEvents();
        },
        initFormEvents: initFormEvents
    };

}());
