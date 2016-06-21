var TablasHelper = {
    /**
     * Evento para que las filas de las tablas sean clickeables
     */
    filasClickeablesEvent: function() {
        $('body').on('click','tr.fila-clickeable', function(e){
            window.location = $(this).data('url');
        });
    },
    /**
     * Evento para calcular subtotales y total en una tabla
     * cada fila debe tener un campo con la clase .cantidad y otro con la clase .precio-unitario
     *
     * @param opciones el selector de la tabla {selector: , callbackParaElTotal: funcion para acceder al total}
     */
    calcularTotalEvent: function(opciones) {
        var tabla = $(opciones.selector);

        tabla.on('keyup change', '.cantidad, .precio-unitario', function(){
            var fila = $(this).parents('tr'),
                cantidad = NumberHelper.aNumero(fila.find('.cantidad').val()),
                precio =   NumberHelper.aNumero(fila.find('.precio-unitario').val()),
                total = 0,
                subtotal = cantidad * precio;

                // si ambos campos no son visibles no se cuenta
                if((fila.find('.cantidad:visible').length + fila.find('.precio-unitario:visible').length) == 0)
                    subtotal = 0;

                fila.find('.subtotal-col span').text(I18n.toCurrency(subtotal, {unit: ''}));

                tabla.find('.subtotal-col span').each(function(){
                    total += NumberHelper.aNumero($(this).text());
                });

                tabla.find('.table-total span')
                    .data('total', total)
                    .text(NumberHelper.aMoneda(total));

                if(opciones.hasOwnProperty('callbackParaElTotal'))
                    opciones.callbackParaElTotal(total);

        });

    },
    /**
     * Evento para sumar los totales de recibos/boletas seleccionadas en una tabla.
     * cada fila debe tener un campo con clase .monto-a-sumar y un checkbox con clase .pagar-boleta
     *
     * @param opciones object => { selector: de la table,
     *                             autocompletarCampo: indicador para saber si se debe autocompletar el campo de la moneda por defecto
     *                             totalPorDefecto: objeto jquery del elemento a donde se tiene que poner el total. Ej.: el monto de la moneda por defecto,
     *                             callbackDespuesDeSeleccionar: callback luego de seleccionar las boletas}
     */
    calcularSeleccionados: function(opciones) {
        var tabla = $(opciones.selector),
            autocompletar = true;

        if(opciones.hasOwnProperty('autocompletarCampo'))
            autocompletar = opciones.autocompletarCampo;

        tabla.on('keyup change', '.monto-a-sumar, .pagar-boleta, .usar-credito', function(e){
            var total = 0;

            tabla.find('.monto-a-sumar').each(function(){
                var campo = $(this);
                if(campo.parents('tr').find('.pagar-boleta, .usar-credito').is(':checked')) {
                    total += NumberHelper.aNumero($(this).val());
                }
            });

            tabla.find('.table-total span')
                .data('total', total)
                .text(NumberHelper.aMoneda(total));

            if(autocompletar)
                opciones.totalPorDefecto.val(NumberHelper.aMoneda(total)).trigger('change');

            if(opciones.hasOwnProperty('callbackDespuesDeSeleccionar'))
                opciones.callbackDespuesDeSeleccionar(total);
        });
    }
};