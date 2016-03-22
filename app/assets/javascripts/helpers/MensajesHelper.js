var MensajesHelper = {
    mostrarMensajes: function(mensajes){
        for(var i = 0; i < mensajes.length; i++) {
            noty({type: mensajes[i][0], text: mensajes[i][1]});
        }
    }
};