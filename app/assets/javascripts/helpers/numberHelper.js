var NumberHelper = {
    aCantidad: function(cantidad) {
        return I18n.toNumber(cantidad);
    },
    aMoneda: function(monto) {
        return I18n.toCurrency(monto);
    },
    aNumero: function(texto) {
        var n = parseFloat(texto.replace('.', '').replace(',', '.'));
        return isNaN(n) ? 0 : n;
    },
    mascaraMoneda: function(selector) {
        $(selector).inputmask({ alias: 'decimal',
                                radixPoint: ',',
                                autoGroup: true,
                                groupSeparator: '.',
                                groupSize: 3,
                                digits: 0,
                                allowMinus: false,
                                removeMaskOnSubmit: true });
    },
    mascaraCantidad: function(selector) {
        $(selector).inputmask({ alias: 'decimal',
                                radixPoint: ',',
                                autoGroup: true,
                                groupSeparator: '.',
                                groupSize: 3,
                                digits: 3,
                                allowMinus: false,
                                removeMaskOnSubmit: true });
    }
};
