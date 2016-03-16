var MovimientoMercaderiasUI = (function(){
    var elementos = null,
        buscarMercaderiaUrl = '';

    function initFormEvents(){
        elementos.movimientoForm.validate();

        $('.datepicker').datepicker();

        $('#movimiento-detalles-body').on('cocoon:after-insert', function(e, insertedItem) {
            initMercaderiaSelect();
            NumberHelper.mascaraCantidad('.maskCantidad');
        });
    }

    function formatMercaderias(m) {
        if (m.loading) return 'Buscando...';

        return '<span>' + m.nombre + '</span> <br> <strong>Cod. </strong>' + m.codigo;
    }

    function formatMercaderiasSelection(m) {
        $(m.element).parents('tr').find('.codigo-celda').text(m.codigo);
        return m.nombre;
    }

    function initMercaderiaSelect(){
        $(".mercaderia-select").select2({
            ajax: {
                url: buscarMercaderiaUrl,
                dataType: 'json',
                delay: 250,
                data: function (params) {
                    return {
                        q: { nombre_or_codigo_cont: params.term }, // search term
                        page: params.page
                    };
                },
                processResults: function (data, params) {
                    params.page = params.page || 1;

                    return {
                        results: data.items,
                        pagination: {
                            more: (params.page * 30) < data.total_count
                        }
                    };
                },
                cache: true
            },
            escapeMarkup: function (markup) { return markup; }, // let our custom formatter work
            minimumInputLength: 1,
            templateResult: formatMercaderias, // omitted for brevity, see the source of this page
            templateSelection: formatMercaderiasSelection // omitted for brevity, see the source of this page
        });

    }

    return {
        init: function() {
            elementos = {
                movimientoForm: $('#movimiento-mercaderia-form')
            }
        },
        'new': function() {
            initFormEvents();
        },
        initMercaderiaSelect: initMercaderiaSelect,
        setBuscarMercaderiaUrl: function(url) {
            buscarMercaderiaUrl = url;
        }
    };

}());