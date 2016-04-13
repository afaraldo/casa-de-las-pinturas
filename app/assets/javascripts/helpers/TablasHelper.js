var TablasHelper = {
    filasClickeablesEvent: function() {
        $('body').on('click','tr.fila-clickeable', function(e){
            window.location = $(this).data('url');
        });
    },
    calcularTotalEvent: function(selector) {
        var tabla = $(selector);

        tabla.on('keyup', '.cantidad, .precio-unitario', function(){
            var fila = $(this).parents('tr'),
                cantidad = NumberHelper.aNumero(fila.find('.cantidad').val()),
                precio =   NumberHelper.aNumero(fila.find('.precio-unitario').val()),
                total = 0;

                fila.find('.subtotal-col span').text(I18n.toCurrency(cantidad * precio, {unit: ''}));

                tabla.find('.subtotal-col span').each(function(){
                    total += NumberHelper.aNumero($(this).text());
                });

                tabla.find('.table-total span').text(NumberHelper.aMoneda(total));

        });

    }
};