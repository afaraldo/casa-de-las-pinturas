var PagosUI = (function(){
    var elementos = null,
        buscarProveedorUrl = '';

    function initFormEvents(){

        PersonasUI.buscador({elemento: elementos.proveedorBuscador, url: buscarProveedorUrl});

        elementos.pagosForm.validate({ignore: []}); // validar formulario. ignore: [] es para que valide campos no visibles tambien

        NumberHelper.mascaraMoneda('.maskMoneda');

        DatepickerHelper.initDatepicker('.datepicker');

        elementos.pagosForm.on('click', '.seleccionar-panel', function(e){
            elementos.proveedorBuscador.select2('open');
        });

    }

    return {
        init: function() {
            elementos = {
                pagosForm: $('#pago-form'),
                proveedorBuscador: $('#proveedores-buscador')
            }
        },
        index: function() {
            DatepickerHelper.initDateRangePicker('#date-range');
            PersonasUI.buscador({elemento: elementos.proveedorBuscador, url: buscarProveedorUrl});
        },
        'new': function() {
            initFormEvents();
        },
        'create': function(){
            initFormEvents();
        },
        'edit': function() {
            initFormEvents();
        },
        'update': function(){
            initFormEvents();
        },
        setbuscarProveedorUrl: function(url) {
            buscarProveedorUrl = url;
        }
    };

}());
