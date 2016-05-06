var CajaMovimientosUI = (function(){
    var elementos = null;

    function calcularTotal(){
        $('#caja-movimiento-detalles-body').find('.cantidad').trigger('change');
    }

    function initFormEvents(){
        elementos.movimientoForm.validate({ignore: []}); // validar formulario. ignore: [] es para que valide campos no visibles tambien

        NumberHelper.mascaraMoneda('.maskMoneda');

        DatepickerHelper.initDatepicker('.datepicker');

        $('#caja_movimiento_categoria_gasto_id').select2();

        $(".movimiento-tipo").on("change",function(){
            var tipo =  $('.movimiento-tipo:checked').val();

            if ( tipo === 'egreso' ) {
                $('#categoria-gasto').removeClass('hide');
            }
            else if (tipo === 'ingreso') {
                $('#categoria-gasto').addClass('hide');
            }
        });

        TablasHelper.calcularTotalEvent('.calcular-total');

        calcularTotal();
    }

    return {
        init: function() {
            elementos = {
                movimientoForm: $('#caja-movimiento-form')
            }
        },
        index: function() {
            DatepickerHelper.initDateRangePicker('#date-range');
            
            $(".caja-tipo").on("change",function(){
                var tipo =  $(".caja-tipo option:selected").text();

                if ( tipo === 'Tarjeta' ) {
                    $('#tarjeta-efectivizar').removeClass('hide');
                }
                else if (tipo === 'Efectivo') {
                    $('#tarjeta-efectivizar').addClass('hide');
                }
            });
        },
        'new': function() {
            initFormEvents();
        },
        'create': function(){
            initFormEvents();
        },
        'edit': function() {
            initFormEvents();
        },
        'update': function(){
            initFormEvents();
        }
    };

}());