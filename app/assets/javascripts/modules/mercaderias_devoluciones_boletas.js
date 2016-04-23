var DevolucionesUI = (function(){
    var elementos = null,
        buscarProveedorUrl = '';

    function initFormEvents(){

       PersonasUI.buscador({elemento: elementos.proveedorBuscador, url: buscarProveedorUrl});
        
        DatepickerHelper.initDatepicker('.datepicker');

    }

    return {
        init: function() {
            elementos = {
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
        setBuscarProveedorUrl: function(url) {
            buscarProveedorUrl = url;
        }
    };

}());
