var TransferenciasUI = (function(){
    var elementos = null;

    function calcularTotal(){
        $('#caja-movimiento-detalles-body').find('.cantidad').trigger('change');
    }

    function initFormEvents(){
        elementos.movimientoForm.validate({ignore: []}); // validar formulario. ignore: [] es para que valide campos no visibles tambien

        NumberHelper.mascaraMoneda('.maskMoneda');

        DatepickerHelper.initDatepicker('.datepicker');

        TablasHelper.calcularTotalEvent('.calcular-total');

        calcularTotal();
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
        }
    };

}());
