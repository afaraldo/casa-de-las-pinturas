var MovimientoMercaderiasUI = (function(){
    var elementos = null,
        buscarMercaderiaUrl = '';

    function initFormEvents(){
        elementos.movimientoForm.validate({ignore: []});

        $('.datepicker').datepicker();

        $('#movimiento-detalles-body').on('cocoon:after-insert', function(e, insertedItem) {

            MercaderiasUI.buscarMercaderia({elemento: insertedItem.find('.mercaderia-select'), url: buscarMercaderiaUrl});
            NumberHelper.mascaraCantidad('.maskCantidad');
            // Se vuelve a mostar el boton de eliminar si es que se escondio en algun momento
            $('.remove_fields').removeClass('hide');

        }).on('cocoon:after-remove', function(e, removedItem) {

            // Se esconde el boton de eliminar si es que ya queda solo uno
            var tBody = $(this);
            if(tBody.find('.nested-fields').length == 1){
                $('.remove_fields').addClass('hide');
            }

        });

        MercaderiasUI.buscarMercaderia({elemento: $('.mercaderia-select'), url: buscarMercaderiaUrl});

        NumberHelper.mascaraCantidad('.maskCantidad');

        if($('.nested-fields').length == 1){
            $('.remove_fields').addClass('hide');
        }

    }

    return {
        init: function() {
            elementos = {
                movimientoForm: $('#movimiento-mercaderia-form')
            }
        },
        index: function() {
            $('.input-daterange')
                .datepicker({autoclose: false}) // inicializar rango de fechas del buscador
                .on('changeDate', function(e){ // Evento para hacer submit al formulario cuando se cambia la fecha
                    $(this).parents('.remote-search').submit();
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
        setBuscarMercaderiaUrl: function(url) {
            buscarMercaderiaUrl = url;
        }
    };

}());