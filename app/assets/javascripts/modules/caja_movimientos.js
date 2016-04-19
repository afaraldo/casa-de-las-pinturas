var CajaMovimientosUI = (function(){
    var elementos = null,
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

            // Se inicializa el buscador de mercaderias y se agrega mascara a los campos del nuevo detalle
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

            DatepickerHelper.initDateRangePicker('#rango-de-fecha');
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
        setBuscarMonedaUrl: function(url) {
            buscarMonedaUrl = url;
        }
    };

}());