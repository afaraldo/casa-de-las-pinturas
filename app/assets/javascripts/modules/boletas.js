var BoletasUI = (function(){
    var elementos = null,
        buscarMercaderiaUrl = '',
        buscarPersonaUrl = '';

    function initFormEvents(){
        elementos.boletaForm.validate({ignore: []}); // validar formulario. ignore: [] es para que valide campos no visibles tambien

        PersonasUI.buscador({elemento: elementos.personasBuscador, url: buscarPersonaUrl, customSelection: true});
        MercaderiasUI.buscarMercaderia({elemento: $('.mercaderia-select'), url: buscarMercaderiaUrl});

        NumberHelper.mascaraCantidad('.maskCantidad');
        NumberHelper.mascaraMoneda('.maskMoneda');

        TablasHelper.calcularTotalEvent('.calcular-total');
        TablasHelper.calcularTotalEvent('.calcular-pagos-total');

        DatepickerHelper.initDatepicker('#boleta-fecha');
        DatepickerHelper.initDatepicker('#boleta-fecha-vencimiento', 'nolimitar');

        $(".boleta-condicion").on("change",function(){
            var condicion = $('.boleta-condicion:checked').val();

            if ( condicion === 'contado' ) {
                $('#fecha-vencimiento-wrapper').addClass('hide');
                $('#credito-persona-info').addClass('hide');
            }
            else if (condicion === 'credito') {
                $('#fecha-vencimiento-wrapper').removeClass('hide');
                $('#credito-persona-info').removeClass('hide');
            }
        });


        if($('.nested-fields').length == 1){
            $('.remove_fields').addClass('hide');
        }

        /*
            Eventos al agregar/eliminar detalles
         */
        $('#boleta-detalles-body').on('cocoon:after-insert', function(e, insertedItem) { // Evento luego de insertar un detalle

            // Se inicializa el buscador de mercaderias y se agrega mascara a los campos del nuevo detalle
            MercaderiasUI.buscarMercaderia({elemento: insertedItem.find('.mercaderia-select'), url: buscarMercaderiaUrl});
            NumberHelper.mascaraCantidad('.maskCantidad');
            NumberHelper.mascaraMoneda('.maskMoneda');

            // Se vuelve a mostar el boton de eliminar si es que se escondio en algun momento
            $('.remove_fields').removeClass('hide');

        }).on('cocoon:after-remove', function(e, removedItem) {

            // Se esconde el boton de eliminar si es que ya queda solo uno
            var tBody = $(this);
            if(tBody.find('.nested-fields:visible').length == 1){
                $('.remove_fields').addClass('hide');
            }

        });

    }

    return {
        init: function() {
            elementos = {
                boletaForm: $('#boleta-form'),
                personasBuscador: $('#personas-buscador')
            }
        },
        index: function() {
          DatepickerHelper.initDateRangePicker('#date-range');
          PersonasUI.buscador({elemento: elementos.personasBuscador, url: buscarPersonaUrl});
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
        },
        setBuscarPersonasUrl: function(url) {
            buscarPersonaUrl = url;
        }
    };

}());
