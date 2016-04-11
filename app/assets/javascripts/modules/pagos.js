var PagosUI = (function(){
    var elementos = null,
        buscarProveedorUrl = '';

    function initFormEvents(){

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
