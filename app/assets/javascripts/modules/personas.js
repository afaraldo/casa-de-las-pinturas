var PersonasUI = (function(){

    // Retorna como se muestra cada opcion: Nombre de la persona
    function formatPersonas(m) {
        return '<span>' + m.nombre + '</span>';
    }

    // Lo que se muestra despues de seleccionar
    function formatPersonasSelection(m) {
      $("#limite_credito").html(NumberHelper.aMoneda(m.limite_credito));
      return m.nombre;
    }

    return {
        buscador: function(opciones){
            opciones.elemento.select2({
                minimumInputLength: 2,
                allowClear: true,
                ajax: {
                    url: opciones.url,
                    datatype: 'jsonp',
                    data: function(term,page){
                        return {
                            q: { nombre_or_numero_documento_cont: term }, // search term
                            page: page
                        };
                    },
                    results: function(data, page){
                        var more = (page * 25) < data.total_count;
                        return {
                            results: data.items,
                            more: more
                        };
                    }
                },
                initSelection: function(element, callback) {
                    callback($(element).data('proveedor')); // Se setea la mercaderia si ya esta seleccionada
                },
                formatResult: formatPersonas,
                formatSelection: formatPersonasSelection,
                escapeMarkup: function(m) { return m; }
            });
        }
    };
  }());
