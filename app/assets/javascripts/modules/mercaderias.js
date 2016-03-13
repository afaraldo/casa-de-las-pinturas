var MercaderiasUI = (function(){

    // Formatear categorias para los estilos
    function formatCategorias(categoria) {
        var esPadre = typeof $(categoria.element).data('espadre') === 'undefined';
        return '<span class="'+ (esPadre ? 'parent-categoria' : 'subcategoria') +'">' + categoria.text + '</span>';
    }

    function recargarCategorias() {
        $('#mercaderia_categoria_id').select2({
            templateResult: formatCategorias,
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

            // Validate form
            var form = $('#mercaderia-form');
            form.validate();
        },
        recargarCategorias: recargarCategorias
    };

}());