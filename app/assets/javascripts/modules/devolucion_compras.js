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
    /**
     * Mensaje que indica que el proveedor seleccionado no tiene boletas pendientes
     * @param proveedor
     */
    function noHayBoletas(proveedor){
        elementos.mensajePanel.find('h3').text('No hay boletas para el proveedor ' + proveedor);
        elementos.mensajePanel.find('.seleccionar-panel i').removeClass('fa-search').addClass('fa-list');
        elementos.mensajePanel.find('.overlay').addClass('hide');
        elementos.boletasPanel.addClass('hide');
        elementos.detallesPanel.addClass('hide');
        elementos.mensajePanel.removeClass('hide');
    }
    /**
     * Muestra el panel de las boletas y los detalles del pago
     * Esconde el panel del mensaje inicial
     */
    function mostrarBoletas(limpiarDetalles) {
        elementos.mensajePanel.addClass('hide');
        elementos.detallesPanel.removeClass('hide');

    }


    function initFormEvents(){
        PersonasUI.buscador({elemento: elementos.proveedorBuscador, url: buscarProveedorUrl});

        elementos.devolucionCompraForm.validate({ignore: []}); // validar formulario. ignore: [] es para que valide campos no visibles tambien

        NumberHelper.mascaraMoneda('.maskMoneda');
        NumberHelper.mascaraCantidad('.maskCantidad');

        DatepickerHelper.initDatepicker('.datepicker');
        TablasHelper.calcularTotalEvent('.detalles-table');

        // Abrir el buscador de proveedores cuando se hace click en el panel inicial
        elementos.devolucionCompraForm.on('click', '.seleccionar-panel', function(e){
            elementos.proveedorBuscador.select2('open');
        });

        elementos.proveedorBuscador.on('change',function(e){
            var boleta = $('#devolucion_id');

            if($(this).val() !== '') {
                $.ajax({
                    url: 'get_compras',
                    type: 'get',
                    dataType: 'json',
                    data: {persona_id: $(this).val()},
                    success: function (response) {
                        boleta.html('<option>').attr('value', "");
                        $.each(response, function (i, option) {
                            boleta.append($('<option>').text(option.id).attr('value', option.id));
                        });
                        boleta.select2();
                    }

                });
            }
        });

        $('#devolucion_id').on('change',function(){
            $("#devolucion-mensajes").addClass("hide");
            $('#pago-boletas-devoluciones').removeClass("hide");
            
            $.ajax({
                url: 'buscar_compra',
                type:'get',
                dataType:'script',
                data: {compra_id:$(this).val()}
                
            });
        });

        if($('.nested-fields').length == 1){
            $('.remove_fields').addClass('hide');
        }
        
        $('#compra-detalles-body').on('cocoon:after-remove', function(e, removedItem) {

            // Se esconde el boton de eliminar si es que ya queda solo uno
            var tBody = $(this);
            if(tBody.find('.nested-fields:visible').length == 1){
                $('.remove_fields').addClass('hide');
            }

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
                proveedorBuscador: $('#personas-buscador'),
                mensajePanel: $('#devolucion-mensajes'),
                detallesPanel: $('#pago-boletas-devoluciones')
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
            mostrarBoletas(false);
            
        },
        'edit': function() {
            initFormEvents();
            mostrarBoletas(false);
            
        },
        'update': function(){
            initFormEvents();
            mostrarBoletas(false);

        },
        
        setBuscarProveedorUrl: function(url) {
            buscarProveedorUrl = url;
        }
    };

}());