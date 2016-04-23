var DevolucionesUI = (function(){
    var elementos = null,
        buscarProveedorUrl = '',
        boletasPendientesUrl = '';
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

    function initFormEvents(autocompletarMonedaPorDefecto){

       PersonasUI.buscador({elemento: $('#proveedores-buscador'), url: buscarProveedorUrl, customSelection: true});

        DatepickerHelper.initDatepicker('.datepicker');

        // Abrir el buscador de proveedores cuando se hace click en el panel inicial
        elementos.devolucionesForm.on('click', '.seleccionar-panel', function(e){
            elementos.proveedorBuscador.select2('open');
        });

        // Buscar boletas y devoluciones pendientes del proveedor
        elementos.proveedorBuscador.on('change', function(e){
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

    }

    return {
        init: function() {
            elementos = {
                devolucionesForm: $('#devolucion-form'),
                proveedorBuscador: $('#proveedores-buscador')            }
        },
        index: function() {
            DatepickerHelper.initDateRangePicker('#date-range');
            PersonasUI.buscador({elemento: elementos.proveedorBuscador, url: buscarProveedorUrl});
        },
        'new': function() {
            initFormEvents(true);
        },
        'create': function(){
            initFormEvents(false);
            mostrarDevoluciones(false)
        },
        'edit': function() {
            initFormEvents(false);
            mostrarDevoluciones(false);
        },
        'update': function(){
            initFormEvents(false);
            mostrarDevoluciones(false);
        },
        setbuscarProveedorUrl: function(url) {
            buscarProveedorUrl = url;
        }
    };

}());
