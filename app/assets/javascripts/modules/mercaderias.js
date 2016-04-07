var MercaderiasUI = (function(){

    // Formatear categorias para los estilos
    function formatCategorias(categoria) {
        var esPadre = typeof $(categoria.element).data('espadre') === 'undefined';
        return '<span class="'+ (esPadre ? 'parent-categoria' : 'subcategoria') +'">' + categoria.text + '</span>';
    }

    function recargarCategorias() {
        $('#mercaderia_categoria_id').select2({
            formatResult: formatCategorias,
            escapeMarkup: function(m) { return m; }
        });
    }

    /**
     * Funciones para inicializar el buscador de mercaderias
     */

    // Retorna como se muestra cada opcion: Nombre de la mercaderia + Codigo
    function formatMercaderias(m) {
        return '<span>' + m.nombre + '</span> <br> <strong>Cod. </strong>' + m.codigo;
    }

    // Lo que se hace al seleccionar una opcion
    // Se coloca el codigo en la celda de codigo
    function formatMercaderiasSelection(m, el) {
        $(el).parents('tr').find('.codigo-celda').text(m.codigo);
        return m.nombre;
    }

    // Recibe una lista de mercaderias y elimina si alguno ya esta seleccionado entre los detalles
    // se asume que los inputs tengan las clase .mercaderia-select
    function eliminarItemsSeleccionados(items) {
        var seleccionados = $.map($('input.mercaderia-select'), function(v,i){ return $(v).val();});

        for(var i = 0; i < items.length; i++) {
            if($.inArray(items[0].id, seleccionados) > -1) {
                items.splice(i, 1);
            }
        }

        return items;
    }

    /**
     * Inicializador del buscador
     * Recibe un objeto con:
     * {
     *   elemento: el objeto jquery del elemento input al que se va a utilizar como buscador,
     *   url: la url del metodo para buscar en el servidor
     * }
     */
    function buscarMercaderia(opciones){
        opciones.elemento.select2({
            placeholder: 'Buscar mercadería...',
            minimumInputLength: 2,
            ajax: {
                url: opciones.url,
                datatype: 'jsonp',
                data: function(term,page){
                    return {
                        q: { nombre_or_codigo_cont: term }, // search term
                        page: page
                    };
                },
                results: function(data, page){
                    var more = (page * 25) < data.total_count;
                    return {
                        results: eliminarItemsSeleccionados(data.items),
                        more: more
                    };
                }
            },
            initSelection: function(element, callback) {
                callback($(element).data('mercaderia')); // Se setea la mercaderia si ya esta seleccionada
            },
            formatResult: formatMercaderias,
            formatSelection: formatMercaderiasSelection,
            escapeMarkup: function(m) { return m; }
        });
    }

    return {
        initFormEvents: function(checkMercaderiaCodigoUrl) {
            // Regla para validar que el codigo sea unico
            $.validator.addClassRules({
                uniqueMercaderiaCodigo: {
                    remote: {
                        url: checkMercaderiaCodigoUrl,
                        type: "get",
                        data: {
                            codigo: function() {
                                return $( "#mercaderia_codigo" ).val();
                            },
                            id: function() {
                                return $('#mercaderia_id').val();
                            }
                        }
                    }
                }
            });

            recargarCategorias();

            // Encascarar campos numericos
            NumberHelper.mascaraCantidad('.maskCantidad');
            NumberHelper.mascaraMoneda('.maskMoneda');

            // Validate form
            var form = $('#mercaderia-form');
            form.validate({ignore: []});
        },
        recargarCategoriaFiltro: function(){
            var categoriasFiltro = $('#mercaderias_categorias_buscador');
            categoriasFiltro.select2({
                formatResult: formatCategorias,
                escapeMarkup: function(m) { return m; }
            });
        },
        recargarCategorias: recargarCategorias,
        buscarMercaderia:   buscarMercaderia
    };

}());