var PersonasUI = (function(){


    // Retorna como se muestra cada opcion: Nombre de la persona
    function formatPersonas(m) {
        return '<span>' + m.nombre + '</span>';
    }

    // Lo que se muestra despues de seleccionar
    function formatPersonasSelection(m) {
      return m.nombre;
    }

    // Lo que se muestra despues de seleccionar
    function formatProveedorSelection(m) {
      $("#limite_credito").html(NumberHelper.aMoneda(m.limite_credito));
      $("#saldo").html(NumberHelper.aMoneda(m.limite_credito - m.saldo_actual));
      $("#link_to_proveedor").attr("href", "/proveedores/" + m.id + "/edit");
      return m.nombre;
    }

    return {
        buscador: function(opciones){
            if(!opciones.hasOwnProperty('proveedor')){
              opciones.proveedor = false;
            }
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
                formatSelection: opciones.proveedor ? formatProveedorSelection : formatPersonasSelection,
                escapeMarkup: function(m) { return m; }
            });
        }
    };
  }());
