var ReportesUI = (function(){
    var elementos = null,
        buscarPersonaUrl = '';

    function initFiltros() {
        DatepickerHelper.initDateRangePicker('#date-range');
        PersonasUI.buscador({elemento: elementos.personasBuscador, url: buscarPersonaUrl});

        $('#reporte-table').on('click', '.ordenar-link', function(e){
            var link = $(this);
            $('#filtro-order-by').val(link.data('order-by'));
            $('#filtro-order-dir').val(link.data('order-dir')).trigger('change');

            e.preventDefault();
        });
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
        },
        dibujarChart: function(labels, totales, tipo){

            var elemento = $('#reporte-chart'),

                opciones = {
                    chart: { type: tipo },
                    xAxis: { categories: labels },
                    yAxis: {
                        title: { text: 'Total' }
                    },
                    title: null,
                    plotOptions: {
                        series: {
                            animation: false
                        }
                    },
                    series: [
                        {
                            name: 'Total',
                            showInLegend: false,
                            data: $.map(totales, function(v){ return parseInt(v); })
                        }
                    ]
                };

            elemento.highcharts(opciones);

        }
    };

}());
