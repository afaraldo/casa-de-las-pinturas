// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require i18n
//= require i18n/translations
//= require ./libs/bootstrap.min.js
//= require ./adminlte/app.js
//= require ./libs/jquery.validation/jquery.validate.js
//= require ./libs/jquery.validation/additional-methods.js
//= require ./libs/jquery.validation/messages_es_AR.js
//= require ./libs/validationsConfig.js
//= require ./libs/jquery.noty.packaged.js
//= require ./libs/jquery.noty.defaults.js
//= require_tree ./modules


// Reference: http://viget.com/inspire/extending-paul-irishs-comprehensive-dom-ready-execution
CasaDeLasPinturas = {
    common: {
        init: function() {

            // Delay para buscar en tiempo real
            $('.remote-search').on('keyup', 'input, select', function () {
                var form = $(this).parents('form');
                delay(function () {
                    // agregar icono de "recargando"
                    var buscadorLista = form.parents('.buscador-listado').next('.buscador-resultados');
                    buscadorLista.append('<div class="overlay"><i class="fa fa-refresh fa-spin"></i></div>');
                    // Enviar formulario
                    form.submit();
                }, 500);
            });

        }
    }

};

var delay = (function(){
    var timer = 0;
    return function(callback, ms){
        clearTimeout (timer);
        timer = setTimeout(callback, ms);
    };
})();

UTIL = {
    exec: function( controller, action ) {
        var ns = CasaDeLasPinturas,
            action = ( action === undefined ) ? "init" : action;

        if ( controller !== "" && ns[controller] && typeof ns[controller][action] == "function" ) {
            ns[controller][action]();
        }
    },

    init: function() {
        var body = document.body,
            controller = body.getAttribute( "data-controller" ),
            action = body.getAttribute( "data-action" );

        UTIL.exec( "common" );
        UTIL.exec( controller );
        UTIL.exec( controller, action );
    }
};

$( document ).on('ready', UTIL.init );
