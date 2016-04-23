var PagosUI = (function(){
    var elementos = null,
        buscarProveedorUrl = '',
        boletasPendientesUrl = '';

    /**
     * Mensaje que indica que el proveedor seleccionado no tiene boletas pendientes
     * @param proveedor
     */
    function noHayPendientes(proveedor){
        elementos.mensajePanel.find('h3').text('No hay boletas pendientes para el proveedor ' + proveedor);
        elementos.mensajePanel.find('.seleccionar-panel i').removeClass('fa-search').addClass('fa-list');
        elementos.mensajePanel.find('.overlay').addClass('hide');
        elementos.boletasPanel.addClass('hide');
        elementos.detallesPanel.addClass('hide');
        elementos.mensajePanel.removeClass('hide');
    }

    /**
     * Mensaje que muestra un mensaje para indicar que debe seleccionar un proveedor
     */
    function seleccioneProveedor(){
        elementos.mensajePanel.find('h3').text('Seleccione un proveedor para ver las boletas y devoluciones pendientes');
        elementos.mensajePanel.find('.seleccionar-panel i').removeClass('fa-list').addClass('fa-search');
        elementos.mensajePanel.removeClass('hide');
        elementos.boletasPanel.addClass('hide');
        elementos.detallesPanel.addClass('hide');
        elementos.mensajePanel.find('.overlay').addClass('hide');
    }

    /**
     * Muestra el panel de las boletas y los detalles del pago
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
            $(elementos.boletasPanel.find('.monto-a-sumar')[0]).trigger('change');
            elementos.detallesPanel.find('.cantidad').trigger('change');
        }
    }

    function initFormEvents(autocompletarMonedaPorDefecto){

        PersonasUI.buscador({elemento: elementos.personasBuscador, url: buscarProveedorUrl});

        elementos.pagosForm.validate({ignore: []}); // validar formulario. ignore: [] es para que valide campos no visibles tambien

        NumberHelper.mascaraMoneda('.maskMoneda');

        DatepickerHelper.initDatepicker('.datepicker');

        // Abrir el buscador de proveedores cuando se hace click en el panel inicial
        elementos.pagosForm.on('click', '.seleccionar-panel', function(e){
            elementos.personasBuscador.select2('open');
        });

        // Buscar boletas y devoluciones pendientes del proveedor
        elementos.personasBuscador.on('change', function(e){
            if($(this).val() === ''){
                seleccioneProveedor();
                return false;
            }

            $.ajax(boletasPendientesUrl + '?proveedor_id=' + $(this).val(), {
                dataType: 'script',
                beforeSend: function(){
                    elementos.mensajePanel.find('.overlay').removeClass('hide');
                }
            })
        });

        // Validar que se seleccione por lo menos una boleta
        // y que el total de boletas seleccionadas sea igual al total de detalles de l pago
        elementos.pagosForm.on('submit', function(e){
            var form = $(this);

            if(form.find('.pagar-boleta:checked').length == 0 && form.valid()){
                elementos.validacionBoletasSeleccionadas.removeClass('hide');
                MensajesHelper.irHasta(elementos.validacionBoletasSeleccionadas.offset().top);
                e.preventDefault();
            }
            var totalDetalles = elementos.detallesPanel.find('.table-total span').data('total'),
                totalBoletas = elementos.boletasPanel.find('.table-total span').data('total');

            if(totalBoletas != totalDetalles){
                elementos.validacionTotalDetalles.removeClass('hide');
                e.preventDefault();
            }

        });

        TablasHelper.calcularSeleccionados(
            {   selector: '#compra-detalles-tabla',
                totalPorDefecto: $('.moneda-por-defecto'),
                autocompletarCampo: autocompletarMonedaPorDefecto,
                callbackDespuesDeSeleccionar: function(){ // Cuando se selecciona alguna boleta se esconde la validacion
                    if(elementos.pagosForm.find('.pagar-boleta:checked').length > 0){
                        elementos.validacionBoletasSeleccionadas.addClass('hide');
                    }
                }
            }
        );
        TablasHelper.calcularTotalEvent('.calcular-pagos-total');

    }

    return {
        init: function() {
            elementos = {
                pagosForm: $('#pago-form'),
                proveedorBuscador: $('#proveedores-buscador'),
                mensajePanel: $('#pago-mensajes'),
                boletasPanel: $('#pago-boletas-devoluciones'),
                detallesPanel: $('#pago-detalles'),
                validacionBoletasSeleccionadas: $('#boletas-seleccionadas-validation'),
                validacionTotalDetalles: $('#recibo-total-validation')
            }
        },
        index: function() {
            DatepickerHelper.initDateRangePicker('#date-range');
            PersonasUI.buscador({elemento: elementos.personasBuscador, url: buscarProveedorUrl});
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
        setbuscarProveedorUrl: function(url) {
            buscarProveedorUrl = url;
        },
        setboletasPendientesUrl: function(url) {
            boletasPendientesUrl = url;
        }
    };

}());
