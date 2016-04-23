var DatepickerHelper = {
    // Funcion para inicializar un datepicker simple a partir de un selector
    initDatepicker: function(selector, opciones = {}) {
        opciones.endDate = '0d';
        opciones.zIndexOffset = '1001';
        if (opciones.limited === false){
            delete opciones.endDate;
        }
        $(selector).datepicker(opciones);

        // Evento para el boton al lado del campo datepicker
        $(selector + ' + .input-group-btn').on('click', function(e){
            $(this).siblings('.datepicker').datepicker('show');
        });
    },

    initDateRangePicker: function(selector) {
        $(selector).daterangepicker(
            {
                startDate: moment().subtract(30, 'days'),
                endDate: moment(),
                //minDate: '01/01/2012',
                //maxDate: '31/12/2014',
                //dateLimit: { days: 60 },
                showDropdowns: true,
                showWeekNumbers: true,
                timePicker: false,
                timePickerIncrement: 1,
                timePicker12Hour: true,
                ranges: {
                    'Hoy': [moment(), moment()],
                    'Ayer': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
                    'Ultimos 30 dias': [moment().subtract(29, 'days'), moment()],
                    'Este mes': [moment().startOf('month'), moment().endOf('month')]
                },
                opens: 'right',
                buttonClasses: ['btn'],
                applyClass: 'btn-primary btn-sm',
                cancelClass: 'btn-default btn-sm',
                format: 'DD/MM/YYYY',
                separator: ' hasta ',
                locale: {
                    applyLabel: 'Aplicar',
                    cancelLabel: 'Limpiar',
                    fromLabel: 'Desde',
                    toLabel: 'Hasta',
                    customRangeLabel: 'Rango',
                    daysOfWeek: ['Do', 'Lu', 'Ma', 'Mi', 'Ju', 'Vi','Sa'],
                    monthNames: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'],
                    firstDay: 1

                }

            },

            function(start, end) {
                var el = $(selector);
                el.find('.fecha-desde').val(start.format('DD/MM/YYYY')).trigger('change');
                el.find('.fecha-hasta').val(end.format('DD/MM/YYYY')).trigger('change');
                el.find('span').html(start.format('DD/MM/YYYY') + ' - ' + end.format('DD/MM/YYYY'));
            }
        );

        $(selector).on('cancel.daterangepicker', function(ev, picker) {
            var el = $(selector);
            el.find('.fecha-desde').val("").trigger('change');
            el.find('.fecha-hasta').val("").trigger('change');
            el.find('span').html("Fecha");
        });

    }
};
