var ComprasUI = (function(){
    var elementos = null,
        buscarMercaderiaUrl = '',
        buscarProveedorUrl = '';

    function initFormEvents(){
        elementos.compraForm.validate({ignore: []}); // validar formulario. ignore: [] es para que valide campos no visibles tambien

        PersonasUI.buscador({elemento: $('#proveedores-buscador'), url: buscarProveedorUrl, customSelection: true});
        MercaderiasUI.buscarMercaderia({elemento: $('.mercaderia-select'), url: buscarMercaderiaUrl});

        NumberHelper.mascaraCantidad('.maskCantidad');
        NumberHelper.mascaraMoneda('.maskMoneda');

        TablasHelper.calcularTotalEvent('.calcular-total');
        TablasHelper.calcularTotalEvent('.calcular-pagos-total');

        DatepickerHelper.initDatepicker('#compra_fecha');
        DatepickerHelper.initDatepicker('#compra_fecha_vencimiento', 'nolimitar');

        $(".btn-group").on("change",function(){
            if ($('input[name="compra[condicion]"]:checked').val() == 'contado' ) {
                //alert($('input[name="compra[condicion]"]:checked').val());
                $('.compra_fecha_vencimiento').hide();
                $('.alert-info').hide();
            }
            else if ($('input[name="compra[condicion]"]:checked').val() == 'credito') {
                //alert($('input[name="compra[condicion]"]:checked').val());
                $('.compra_fecha_vencimiento').show();
                $('.alert-info').show();
            }
        });


        if($('.nested-fields').length == 1){
            $('.remove_fields').addClass('hide');
        }

        /*
            Eventos al agregar/eliminar detalles
         */
        $('#compra-detalles-body').on('cocoon:after-insert', function(e, insertedItem) { // Evento luego de insertar un detalle

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
                compraForm: $('#compra-form'),
                proveedorBuscador: $('#proveedores-buscador')
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
