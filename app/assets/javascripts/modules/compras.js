var ComprasUI = (function(){
    var elementos = null,
        buscarMercaderiaUrl = '';

    // Retorna como se muestra cada opcion: Nombre de la proveedor
    function formatProveedores(m) {
        return '<span>' + m.nombre + '</span>';
    }

    function recargarProveedoresFiltro(){
      var proveedoresFiltro = $('#proveedores_buscador');
      proveedoresFiltro.select2({
          formatResult: formatProveedores,
          escapeMarkup: function(m) { return m; }
        });
    }

    function initFormEvents(){
        elementos.compraForm.validate({ignore: []}); // validar formulario. ignore: [] es para que valide campos no visibles tambien

        MercaderiasUI.buscarMercaderia({elemento: $('.mercaderia-select'), url: buscarMercaderiaUrl});

        NumberHelper.mascaraCantidad('.maskCantidad');

        DatepickerHelper.initDatepicker('.datepicker');

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

            // Se vuelve a mostar el boton de eliminar si es que se escondio en algun momento
            $('.remove_fields').removeClass('hide');

        }).on('cocoon:after-remove', function(e, removedItem) {

            // Se esconde el boton de eliminar si es que ya queda solo uno
            var tBody = $(this);
            if(tBody.find('.nested-fields').length == 1){
                $('.remove_fields').addClass('hide');
            }

        });

    }

    return {
        init: function() {
            elementos = {
                compraForm: $('#compra-form')
            }
        },
        index: function() {
            $('.input-daterange')
                .datepicker({autoclose: false}) // inicializar rango de fechas del buscador
                .on('changeDate', function(e){ // Evento para hacer submit al formulario cuando se cambia la fecha
                    $(this).parents('.remote-search').submit();
                });

            DatepickerHelper.initDateRangePicker('#rango-de-fecha');
            recargarProveedoresFiltro();
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
