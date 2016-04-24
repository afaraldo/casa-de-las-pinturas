var CuentaCorrientesUI = (function(){
    var elementos = null,
        buscarPersonaUrl = '';

    return {
        init: function() {
            elementos = {
                personaBuscador: $('#persona-buscador')
            };

            DatepickerHelper.initDateRangePicker('#date-range');
            PersonasUI.buscador({elemento: elementos.personaBuscador,
                                 url: buscarPersonaUrl,
                                 allowClear: false});

            $('.seleccionar-panel').on('click', function(e){
                elementos.personaBuscador.select2('open');
            });
            elementos.personaBuscador.on('change',function(e){
                elementos.personaBuscador.trigger('keyup');
            });

        },
        setBuscarPersonaUrl: function(url) {
            buscarPersonaUrl = url;
        }
    };

}());
