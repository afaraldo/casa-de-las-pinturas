var ReportesUI = (function(){
    var elementos = null,
        buscarPersonaUrl = '',
        chartOpciones = { responsive: true,
                          maintainAspectRatio: false,
                          legend: { display: false },
                          tooltips: {callbacks: {label: function(tooltipItem){return 'Total: ' + NumberHelper.aMoneda(tooltipItem.yLabel);}}}
                        };

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
        },
        dibujarChart: function(labels, totales, tipo){
            var contexto = $('#reporte-chart-canvas').get(0).getContext('2d');

            var data = {
                labels: labels,
                datasets: [
                    {
                        label: "Total",
                        fill: true,
                        backgroundColor: "rgba(253, 72, 1, 0.6)",
                        borderColor: "rgb(253, 72, 1)",
                        pointBorderColor: "rgba(220,220,220,1)",
                        pointBackgroundColor: "#fff",
                        pointBorderWidth: 1,
                        pointHoverRadius: 5,
                        pointHoverBackgroundColor: "rgba(220,220,220,1)",
                        pointHoverBorderColor: "rgba(220,220,220,1)",
                        pointHoverBorderWidth: 2,
                        data: totales
                    }
                ]
            };

            new Chart(contexto,  {type: tipo, data: data, options: chartOpciones});
        }
    };

}());
