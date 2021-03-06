var CobrosUI = (function(){
    var elementos = null,
        buscarClienteUrl = '',
        boletasPendientesUrl = '';
        devolucionesPendientesUrl = '';

    /**
     * Mensaje que indica que el cliente seleccionado no tiene boletas pendientes
     * @param cliente
     */
    function noHayPendientes(cliente){
        elementos.mensajePanel.find('h3').text('No hay boletas pendientes para el cliente ' + cliente);
        elementos.mensajePanel.find('.seleccionar-panel i').removeClass('fa-search').addClass('fa-list');
        elementos.mensajePanel.find('.overlay').addClass('hide');
        elementos.boletasPanel.addClass('hide');
        elementos.detallesPanel.addClass('hide');
        elementos.mensajePanel.removeClass('hide');
    }

    /**
     * Mensaje que indica que el cliente seleccionado no tiene devoluciones pendientes
     * @param tipo
     * @param cliente
     */
    function noHayDevoluciones(tipo, cliente){
        elementos.mensajePanel.find('h3').text('No hay devoluciones disponibles para el '+tipo+' ' + cliente);
        elementos.mensajePanel.find('.overlay').addClass('hide');
        elementos.mensajePanel.removeClass('hide');
        elementos.devolucionesTabla.addClass('hide');
        elementos.boletaResumen.addClass('hide');
    }

    /**
     * Mensaje que muestra un mensaje para indicar que debe seleccionar un cliente
     */
    function seleccioneCliente(){
        elementos.mensajePanel.find('h3').text('Seleccione un cliente para ver las boletas y devoluciones pendientes');
        elementos.mensajePanel.find('.seleccionar-panel i').removeClass('fa-list').addClass('fa-search');
        elementos.mensajePanel.removeClass('hide');
        elementos.boletasPanel.addClass('hide');
        elementos.detallesPanel.addClass('hide');
        elementos.mensajePanel.find('.overlay').addClass('hide');
    }

    /**
     * Muestra el panel de las boletas y los detalles del cobro
     * Esconde el panel del mensaje inicial
     */
    function mostrarBoletas(limpiarDetalles) {
        elementos.mensajePanel.addClass('hide');
        elementos.boletasPanel.removeClass('hide');
        elementos.detallesPanel.removeClass('hide');

        NumberHelper.mascaraMoneda('.mascaraMoneda');

        if(limpiarDetalles) {
            elementos.detallesPanel.find('.cantidad').val('0');
        } else {
            elementos.boletasPanel.find('.monto-a-sumar').trigger('change');
            elementos.detallesPanel.find('.cantidad').trigger('change');
        }
    }

    /**
     * Muestra el panel de las devoluciones
     * Esconde el panel del mensaje inicial
     */
    function mostrarDevoluciones() {
        elementos.mensajePanel.addClass('hide');
        elementos.devolucionesTabla.removeClass('hide');
        elementos.boletaResumen.removeClass('hide');

        NumberHelper.mascaraMoneda('.mascaraMoneda');
    }

    function limpiarDevoluciones(){
        $('#creditos-detalles-body').html('');
        $('#res-total-creditos').data('total', 0).text('Gs. 0');
        elementos.detallesTable.find('.cantidad').trigger('change');
    }

    // Usar los data attributes del resumen para calcular el total a cobrar
    function calcularTotalBoleta(){
        var aCobrar = parseInt($('#res-total-boleta').data('total')) - parseInt($('#res-total-creditos').data('total'));
        $('.moneda-por-defecto').val(NumberHelper.aMoneda(aCobrar)).trigger('change');
        $('#res-total-a-cobrar').text(NumberHelper.aMoneda(aCobrar));
    }

    function initFormEvents(autocompletarMonedaPorDefecto){

        PersonasUI.buscador({elemento: elementos.personasBuscador, url: buscarClienteUrl});

        elementos.cobrosForm.validate({ignore: []}); // validar formulario. ignore: [] es para que valide campos no visibles tambien

        NumberHelper.mascaraMoneda('.maskMoneda');

        DatepickerHelper.initDatepicker('.datepicker');

        // Abrir el buscador de clientes cuando se hace click en el panel inicial
        elementos.cobrosForm.on('click', '.seleccionar-panel', function(e){
            elementos.personasBuscador.select2('open');
        });

        // Buscar boletas y devoluciones pendientes del cliente
        elementos.personasBuscador.on('change', function(e){
            if($(this).val() === ''){
                seleccioneCliente();
                return false;
            }

            $.ajax(boletasPendientesUrl + '?cliente_id=' + $(this).val(), {
                dataType: 'script',
                beforeSend: function(){
                    elementos.mensajePanel.find('.overlay').removeClass('hide');
                }
            })
        });

        // Validar que se seleccione por lo menos una boleta
        // y que el total de boletas seleccionadas sea igual al total de detalles del cobro
        elementos.cobrosForm.on('submit', function(e){
            var form = $(this);

            if(form.find('.pagar-boleta:checked').length == 0 && form.valid()){
                elementos.validacionBoletasSeleccionadas.removeClass('hide');
                MensajesHelper.irHasta(elementos.validacionBoletasSeleccionadas.offset().top);
                e.preventDefault();
            }
            var totalDetalles = parseInt($('#cobro-detalles').find('.table-total span').data('total')),
                totalBoletas = parseInt($('#venta-detalles-tabla').find('.table-total span').data('total')),
                creditos = parseInt($('#res-total-creditos').data('total'));

            if((totalBoletas - creditos) != totalDetalles){
                elementos.validacionTotalDetalles.removeClass('hide');
                e.preventDefault();
            }

        });

        // Calculador de devoluciones seleccionadas
        TablasHelper.calcularSeleccionados(
            {   selector: '#creditos-disponibles-tabla',
                autocompletarCampo: false,
                callbackDespuesDeSeleccionar: function(credito){
                    // setear el credito utilizado en el resumen
                    $('#res-total-creditos').data('total', credito).text(NumberHelper.aMoneda(credito));
                    calcularTotalBoleta();
                }
            }
        );

        TablasHelper.calcularSeleccionados(
            {   selector: '#venta-detalles-tabla',
                totalPorDefecto: $('.moneda-por-defecto'),
                autocompletarCampo: false,
                callbackDespuesDeSeleccionar: function(total){ // Cuando se selecciona alguna boleta se esconde la validacion
                    if(elementos.cobrosForm.find('.pagar-boleta:checked').length > 0){
                        elementos.validacionBoletasSeleccionadas.addClass('hide');
                    }
                    // setear el credito utilizado en el resumen
                    $('#res-total-boleta').data('total', total).text(NumberHelper.aMoneda(total));
                    calcularTotalBoleta();

                }
            }
        );
        TablasHelper.calcularTotalEvent({selector: '.calcular-cobros-total'});

    }

    return {
        init: function() {
            elementos = {
                cobrosForm: $('#cobro-form'),
                personasBuscador: $('#personas-buscador'),
                mensajePanel: $('#cobro-mensajes'),
                boletasPanel: $('#pago-boletas-devoluciones'),
                detallesPanel: $('#cobro-detalles'),
                validacionBoletasSeleccionadas: $('#boletas-seleccionadas-validation'),
                validacionTotalDetalles: $('#recibo-total-validation'),
                boletaResumen: $('#boleta-resumen'),
                devolucionesTabla: $('#credito-devoluciones')
            }
        },
        index: function() {
            DatepickerHelper.initDateRangePicker('#date-range');
            PersonasUI.buscador({elemento: elementos.personasBuscador, url: buscarClienteUrl});
        },
        'new': function() {
            initFormEvents(true);
        },
        'create': function(){
            initFormEvents(false);
            mostrarBoletas(false)
        },
        'edit': function() {
            initFormEvents(false);
            mostrarBoletas(false);
        },
        'update': function(){
            initFormEvents(false);
            mostrarBoletas(false);
        },
        noHayPendientes: noHayPendientes,
        mostrarBoletas: mostrarBoletas,
        setbuscarClienteUrl: function(url) {
            buscarClienteUrl = url;
        },
        setboletasPendientesUrl: function(url) {
            boletasPendientesUrl = url;
        },
        setDevolucionesPendientesUrl: function(url) {
            devolucionesPendientesUrl = url;
        },
        noHayDevoluciones: noHayDevoluciones,
        mostrarDevoluciones: mostrarDevoluciones
    };

}());
