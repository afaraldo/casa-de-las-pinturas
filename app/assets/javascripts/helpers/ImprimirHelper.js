var ImprimirHelper = {
    /**
     * Funcion para agregar evento al boton .imprimir-listado
     */
    imprimirEvento: function(){
        $('body').on('click', '.imprimir-listado', function(e){
            var btn = $(this),
                url = btn.attr('href'),
                filtros = $('.remote-search');

            if(filtros.length > 0)
                url += '?' + filtros.serialize();

            window.open(url,'_blank');

            e.preventDefault();
        });
    }
};