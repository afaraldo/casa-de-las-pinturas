var TablasHelper = {
    filasClickeablesEvent: function() {
        $('tr.fila-clickeable').on('click', function(e){
            window.location = $(this).data('url');
        });
    }
};