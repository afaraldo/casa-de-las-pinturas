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
        elementos.devolucionesTabla.find('.monto-a-sumar').trigger('change');
    }

    function getCondicionDePago(){
        return $('.boleta-condicion:checked').val();
    }

    /**
     * Mensaje que indica que el proveedor seleccionado no tiene devoluciones pendientes
     * @param tipo
     * @param proveedor
     */
    function noHayDevoluciones(tipo, proveedor){
        elementos.mensajePanel.find('h3').text('No hay devoluciones disponibles para el '+tipo+' ' + proveedor);
        elementos.mensajePanel.find('.overlay').addClass('hide');
        elementos.mensajePanel.removeClass('hide');
        elementos.devolucionesTabla.addClass('hide');
    }

    /**
     * Mensaje que muestra un mensaje para indicar que debe seleccionar un proveedor
     */
    function seleccionePersona(tipo){
        elementos.mensajePanel.find('h3').text('Seleccione un '+tipo+' para ver las devoluciones disponibles');
        elementos.mensajePanel.removeClass('hide');
        elementos.devolucionesTabla.addClass('hide');
        elementos.mensajePanel.find('.overlay').addClass('hide');
    }

    /**
     * Muestra el panel de las devoluciones
     * Esconde el panel del mensaje inicial
     */
    function mostrarDevoluciones() {
        elementos.mensajePanel.addClass('hide');
        elementos.devolucionesTabla.removeClass('hide');

        NumberHelper.mascaraMoneda('.mascaraMoneda');
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

        TablasHelper.calcularTotalEvent({selector: '.calcular-pagos-total'});

        DatepickerHelper.initDatepicker('#boleta-fecha');
        DatepickerHelper.initDatepicker('#boleta-fecha-vencimiento', {limited: false, orientation: 'bottom'});

        // Mostrar / esconder fecha de vencimiento, credito disponible y tabla de formas de pago al cambiar la condicion
        $(".boleta-condicion").on("change",function(){
            var condicion = getCondicionDePago();

            if ( condicion === 'contado' ) {
                $('#fecha-vencimiento-wrapper').addClass('hide');
                $('#credito-persona-info').addClass('hide');
                $('#pago-detalles').removeClass('hide');
                elementos.personaDevoluciones.removeClass('hide');
                elementos.boletaResumen.removeClass('hide');
            }
            else if (condicion === 'credito') {
                $('#fecha-vencimiento-wrapper').removeClass('hide');
                $('#credito-persona-info').removeClass('hide');
                $('#pago-detalles').addClass('hide');
                elementos.personaDevoluciones.addClass('hide');
                elementos.boletaResumen.addClass('hide');

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

        if($('#creditos-detalles-body').find('tr').length > 0){
            mostrarDevoluciones();
        }

        // Buscar devoluciones pendientes de la persona
        elementos.personasBuscador.on('change', function(e){

            limpiarDevoluciones();

            if($(this).val() === ''){
                seleccionePersona(getModulo() === 'compras' ? 'proveedor' : 'cliente');
                return false;
            }

            $.ajax(devolucionesPendientesUrl + '?persona_id=' + $(this).val(), {
                dataType: 'script',
                beforeSend: function(){
                    elementos.mensajePanel.find('.overlay').removeClass('hide');
                }
            })
        });

        // Calculador de mercaderias
        TablasHelper.calcularTotalEvent({
            selector: '.calcular-total',
            callbackParaElTotal: function(total){
                // setear el total de mercaderias en el resumen
                $('#res-total-mercaderia').data('total', total).text(NumberHelper.aMoneda(total));
                calcularTotalBoleta();
            }
        });

        // Calculador de devoluciones seleccionadas
        TablasHelper.calcularSeleccionados(
            {   selector: '#devoluciones-disponibles-tabla',
                autocompletarCampo: false,
                callbackDespuesDeSeleccionar: function(credito){
                    // setear el credito utilizado en el resumen
                    $('#res-total-creditos').data('total', credito).text(NumberHelper.aMoneda(credito));
                    calcularTotalBoleta();
                }
            }
        );

    }

    function limpiarDevoluciones(){
        $('#creditos-detalles-body').html('');
        $('#res-total-creditos').data('total', 0).text('Gs. 0');
        elementos.detallesTable.find('.cantidad').trigger('change');
    }

    // Usar los data attributes del resumen para calcular el total a pagar
    function calcularTotalBoleta(){
        var aPagar = parseInt($('#res-total-mercaderia').data('total')) - parseInt($('#res-total-creditos').data('total'));

        $('#res-total-a-pagar').text(NumberHelper.aMoneda(aPagar));
    }

    return {
        init: function() {
            elementos = {
                boletaForm: $('#boleta-form'),
                personasBuscador: $('#personas-buscador'),
                detallesTable: $('.detalles-table'),
                personaDevoluciones: $('#devoluciones-persona'),
                boletaResumen: $('#boleta-resumen'),
                mensajePanel: $('#mensaje-devoluciones'),
                devolucionesTabla: $('#devoluciones-disponibles-tabla')
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
        },
        noHayDevoluciones: noHayDevoluciones,
        mostrarDevoluciones: mostrarDevoluciones,
        seleccionePersona: seleccionePersona
    };

}());
