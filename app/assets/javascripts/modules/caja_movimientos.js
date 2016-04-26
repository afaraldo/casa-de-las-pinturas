var CajaMovimientosUI = (function(){
    var elementos = null,
        buscarCajaUrl = '';
        buscarMonedaUrl = '';

    function initFormEvents(){
        elementos.movimientoForm.validate({ignore: []}); // validar formulario. ignore: [] es para que valide campos no visibles tambien

        NumberHelper.mascaraMoneda('.maskMoneda');

        DatepickerHelper.initDatepicker('.datepicker');

        if($('.nested-fields').length == 1){
            $('.remove_fields').addClass('hide');
        }

        /*
            Eventos al agregar/eliminar detalles
         */
        $('#caja-movimiento-detalles-body').on('cocoon:after-insert', function(e, insertedItem) { // Evento luego de insertar un detalle

            // Se inicializa el buscador y se agrega mascara a los campos del nuevo detalle
            NumberHelper.mascaraMoneda('.maskMoneda');

            // Se vuelve a mostar el boton de eliminar si es que se escondio en algun momento
            $('.remove_fields').removeClass('hide');

        }).on('cocoon:after-remove', function(e, removedItem) {

            // Se esconde el boton de eliminar si es que ya queda solo uno
            var tBody = $(this);
            if(tBody.find('.nested-fields').length == 1){
                $('.remove_fields').addClass('hide');
            }

        });
        $(".movimiento-tipo").on("change",function(){
            var tipo =  $('.movimiento-tipo:checked').val();

            if ( tipo === 'egreso' ) {
                $('#categoria-gasto').removeClass('hide');
            }
            else if (tipo === 'ingreso') {
                $('#categoria-gasto').addClass('hide');
            }
        });

    }

    return {
        init: function() {
            elementos = {
                movimientoForm: $('#caja-movimiento-form')
            }
        },
        index: function() {
            $('.input-daterange')
                .datepicker({autoclose: false}) // inicializar rango de fechas del buscador
                .on('changeDate', function(e){ // Evento para hacer submit al formulario cuando se cambia la fecha
                    $(this).parents('.remote-search').submit();
                });
            DatepickerHelper.initDateRangePicker('#date-range');
            
            $(".caja-tipo").on("change",function(){
                var tipo =  $(".caja-tipo option:selected").text();

                if ( tipo === 'tarjeta' ) {
                    $('#tarjeta-efectivizar').removeClass('hide');
                }
                else if (tipo === 'efectivo') {
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
        },
        setBuscarCajaUrl: function(url) {
            buscarCajaUrl = url;
        },
        setBuscarMonedaUrl: function(url) {
            buscarMonedaUrl = url;
        }
    };

}());