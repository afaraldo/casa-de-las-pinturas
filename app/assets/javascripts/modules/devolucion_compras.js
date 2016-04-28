DevolucionComprasUI= (function(){
    var elementos = null,
        buscarMercaderiaUrl = '',
        buscarProveedorUrl = '';
        /**
     * Mensaje que muestra un mensaje para indicar que debe seleccionar un proveedor
     */
    function seleccioneProveedor(){
        elementos.mensajePanel.find('h3').text('Seleccione un proveedor para ver las boletas para la devolucion');
        elementos.mensajePanel.find('.seleccionar-panel i').removeClass('fa-list').addClass('fa-search');
        elementos.mensajePanel.removeClass('hide');
        elementos.boletasPanel.addClass('hide');
        elementos.detallesPanel.addClass('hide');
        elementos.mensajePanel.find('.overlay').addClass('hide');
    }


    function initFormEvents(){
        PersonasUI.buscador({elemento: elementos.proveedorBuscador, url: buscarProveedorUrl});

        elementos.devolucionCompraForm.validate({ignore: []}); // validar formulario. ignore: [] es para que valide campos no visibles tambien

        NumberHelper.mascaraMoneda('.maskMoneda');

        DatepickerHelper.initDatepicker('.datepicker');

        // Abrir el buscador de proveedores cuando se hace click en el panel inicial
        elementos.devolucionCompraForm.on('click', '.seleccionar-panel', function(e){
            elementos.proveedorBuscador.select2('open');
        });


    }

    // Recibe una lista de mercaderias y elimina si alguno ya esta seleccionado entre los detalles
    // se asume que los inputs tengan las clase .proveedor-select
    function eliminarItemsSeleccionados(items) {
        var seleccionados = $.map($('input.proveedor-select'), function(v,i){ return $(v).val();});

        for(var i = 0; i < items.length; i++) {
            if($.inArray(items[0].id, seleccionados) > -1) {
                items.splice(i, 1);
            }
        }

        return items;
    }


    return {
        init: function() {
            elementos = {
                devolucionCompraForm: $('#devolucion-compra-form'),
                proveedorBuscador: $('#proveedores-buscador'),
                mensajePanel: $('#devolucion-compra-mensajes'),
                detallesPanel: $('#devolucion-compra-detalles'),
            }
        },
        index: function() {
          DatepickerHelper.initDateRangePicker('#date-range');
          PersonasUI.buscador({elemento: elementos.proveedorBuscador, url: buscarProveedorUrl});
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
        setBuscarProveedorUrl: function(url) {
            buscarProveedorUrl = url;
        }
    };

}());
