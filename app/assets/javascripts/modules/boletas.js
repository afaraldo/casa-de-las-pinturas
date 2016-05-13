var BoletasUI = (function(){
    var elementos = null,
        buscarMercaderiaUrl = '',
        buscarPersonaUrl = '',
        devolucionesPendientesUrl = '';

    function getModulo() {
        return $('body').data('controller');
    }

    function calcularTotal(){
        elementos.detallesTable.find('.cantidad').trigger('change');
    }

    function getCondicionDePago(){
        return $('.boleta-condicion:checked').val();
    }

    function initFormEvents(){
        var opcionesBuscadorMercaderias = {url: buscarMercaderiaUrl,
                        customSelection: function(m, el){
                            var condicion = getCondicionDePago(),
                                precio = m.precio_venta_contado;

                            $(el).parents('tr').find('.codigo-celda').text(m.codigo);

                            // Para completar el precio de venta si es venta
                            if(getModulo() === 'ventas') {
                                if (condicion === 'credito')
                                    precio = m.precio_venta_credito;

                                var precioInput = $(el).parents('tr').find('.precio-unitario')

                                if(precioInput.val() === '')
                                    precioInput.val(precio);
                            }

                            return m.nombre;
                        }};

        elementos.boletaForm.validate({ignore: []}); // validar formulario. ignore: [] es para que valide campos no visibles tambien

        PersonasUI.buscador({elemento: elementos.personasBuscador, url: buscarPersonaUrl, customSelection: true});
        MercaderiasUI.buscarMercaderia($.extend({elemento: $('.mercaderia-select')}, opcionesBuscadorMercaderias));

        NumberHelper.mascaraCantidad('.maskCantidad');
        NumberHelper.mascaraMoneda('.maskMoneda');

        TablasHelper.calcularTotalEvent('.calcular-total');
        TablasHelper.calcularTotalEvent('.calcular-pagos-total');

        DatepickerHelper.initDatepicker('#boleta-fecha');
        DatepickerHelper.initDatepicker('#boleta-fecha-vencimiento', {limited: false, orientation: 'bottom'});

        // Mostrar / esconder fecha de vencimiento, credito disponible y tabla de formas de pago al cambiar la condicion
        $(".boleta-condicion").on("change",function(){
            var condicion = getCondicionDePago();

            if ( condicion === 'contado' ) {
                $('#fecha-vencimiento-wrapper').addClass('hide');
                $('#credito-persona-info').addClass('hide');
                $('#pago-detalles').removeClass('hide');
            }
            else if (condicion === 'credito') {
                $('#fecha-vencimiento-wrapper').removeClass('hide');
                $('#credito-persona-info').removeClass('hide');
                $('#pago-detalles').addClass('hide');
            }

        }).trigger("change");

        if($('.nested-fields').length == 1){
            $('.remove_fields').addClass('hide');
        }

        /*
            Eventos al agregar/eliminar detalles
         */
        $('#boleta-detalles-body').on('cocoon:after-insert', function(e, insertedItem) { // Evento luego de insertar un detalle

            // Se inicializa el buscador de mercaderias y se agrega mascara a los campos del nuevo detalle
            MercaderiasUI.buscarMercaderia($.extend({elemento: insertedItem.find('.mercaderia-select')}, opcionesBuscadorMercaderias));
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


        // Buscar devoluciones pendientes de la persona
        elementos.personasBuscador.on('change', function(e){
            if($(this).val() === ''){
                return false;
            }

            $.ajax(devolucionesPendientesUrl + '?persona_id=' + $(this).val(), {
                dataType: 'script',
                beforeSend: function(){
                    //elementos.mensajePanel.find('.overlay').removeClass('hide');
                }
            })
        });

        TablasHelper.calcularSeleccionados(
            {   selector: '#compra-detalles-tabla',
                callbackDespuesDeSeleccionar: function(){ // Cuando se selecciona alguna devolucion se esconde la validacion
//                    if(elementos.pagosForm.find('.pagar-boleta:checked').length > 0){
//                        elementos.validacionBoletasSeleccionadas.addClass('hide');
//                    }
                }
            }
        );

    }

    return {
        init: function() {
            elementos = {
                boletaForm: $('#boleta-form'),
                personasBuscador: $('#personas-buscador'),
                detallesTable: $('.detalles-table')
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
            calcularTotal();
        },
        'edit': function() {
            initFormEvents();
            calcularTotal();
        },
        'update': function(){
            initFormEvents();
            calcularTotal();
        },
        setBuscarMercaderiaUrl: function(url) {
            buscarMercaderiaUrl = url;
        },
        setBuscarPersonasUrl: function(url) {
            buscarPersonaUrl = url;
        },
        setDevolucionesPendientesUrl: function(url) {
            devolucionesPendientesUrl = url;
        }
    };

}());
