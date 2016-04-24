var ReportesUI = (function(){
    var elementos = null,
        buscarPersonaUrl = '';

    function initFiltros() {
        DatepickerHelper.initDateRangePicker('#date-range');
        PersonasUI.buscador({elemento: elementos.personasBuscador, url: buscarPersonaUrl});
    }

    return {
        init: function() {
            elementos = {
                personasBuscador: $('#personas-buscador')
            }
        },
        compras: function(){
            initFiltros();
        },
        setBuscarPersonaUrl: function(url) {
            buscarPersonaUrl = url;
        }
    };

}());
