var ReportesUI = (function(){
    var elementos = null,
        buscarPersonaUrl = '';

    function initFiltros() {
        DatepickerHelper.initDateRangePicker('#date-range');

        $('#reporte-table').on('click', '.ordenar-link', function(e){
            var link = $(this);
            $('#filtro-order-by').val(link.data('order-by'));
            $('#filtro-order-dir').val(link.data('order-dir')).trigger('change');

            e.preventDefault();
        });
    }

    function buildSeries(data, mostrarReferencia) {
        var series = [];

        for(var i = 0; i < data.length; i++) {
            var s = data[i];
            series.push(
                {
                    name: s.nombre,
                    showInLegend: mostrarReferencia,
                    data: $.map(s.totales, function(v){ return parseInt(v); })
                }
            );
        }

        return series;
    }

    return {
        init: function() {
            elementos = {
                personasBuscador: $('#personas-buscador')
            }
        },
        compras: function(){
            initFiltros();
            PersonasUI.buscador({elemento: elementos.personasBuscador, url: buscarPersonaUrl});
        },
        gastos: function(){
            initFiltros();
            $('#categorias-buscador').select2();
        },
        caja: function(){
            initFiltros();
        },
        ventas: function(){
            initFiltros();
            PersonasUI.buscador({elemento: elementos.personasBuscador, url: buscarPersonaUrl});
        },
        setBuscarPersonaUrl: function(url) {
            buscarPersonaUrl = url;
        },
        dibujarChart: function(labels, totales, tipo, mostrarReferencia){

            var elemento = $('#reporte-chart'),

                opciones = {
                    chart: { type: tipo },
                    xAxis: { categories: labels },
                    yAxis: {
                        title: { text: 'Total' },
                        labels: {
                            formatter: function() {
                                return I18n.toCurrency(this.value, {unit: ''});
                            }
                        }
                    },
                    title: null,
                    plotOptions: {
                        series: {
                            animation: false
                        }
                    },

                    series: buildSeries(totales, mostrarReferencia)
                };

            elemento.highcharts(opciones);

        }
    };

}());
