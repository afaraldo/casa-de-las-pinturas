// Valores por defecto para jqueryValidation

jQuery.validator.setDefaults({
    errorElement:   'span',
    errorClass:     'help-block',
    highlight: function(element){
        $(element).closest('.form-group').addClass('has-error');
    },
    success: function(element){
        $(element).closest('.form-group').removeClass('has-error');
        $(element).next('.server-error-msg').html('');
    },
    errorPlacement: function(error, element) {
        if(element.parents('.buttons-group').length > 0){
            // Place the error after the buttons
            element.parents('.buttons-group').append(error);
        }else if(element.parents('.radio').length > 0){
            if(element.parents('.form-horizontal').length > 0){
                element.closest('.col-sm-9').append(error);
            } else {
                element.closest('.form-group').append(error);
            }
        }else if(element.parents('.input-group').length > 0){
            element.parents('.input-group').after(error);
        }else{
            error.insertAfter(element);
        }
    }
});


$.validator.addClassRules({
    textoAbreviatura: {
        minlength: 1,
        maxlength: 5
    },
    textoCorto: {
        minlength: 2,
        maxlength: 20
    },
    textoMedio: {
        minlength: 2,
        maxlength: 50
    },
    textoLargo: {
        minlength: 2,
        maxlength: 150
    },
    descripcion: {
        minlength: 2,
        maxlength: 255
    },
    limiteNumero: {
        maxlength: 20
    },
    passwordLength: {
        minlength: 8
    },
    passwordConfirmation: {
        equalTo: '#empleado_user_attributes_password'
    }
});
