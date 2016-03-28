$.noty.themes.bootstrapTheme = {
    name: 'bootstrapTheme',
    modal: {
        css: {
            position: 'fixed',
            width: '100%',
            height: '100%',
            backgroundColor: '#000',
            zIndex: 10000,
            opacity: 0.6,
            display: 'none',
            left: 0,
            top: 0
        }
    },
    style: function() {

        var containerSelector = this.options.layout.container.selector;
        $(containerSelector).addClass('list-group');

        this.$closeButton.append('<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>');
        this.$closeButton.addClass('close');

        this.$bar.addClass( "alert" ).css('padding', '0px');

        switch (this.options.type) {
            case 'alert': case 'notification':
            this.$bar.addClass( "alert-info" );
            break;
            case 'warning':
                this.$bar.addClass( "alert-warning" );
                break;
            case 'error':
                this.$bar.addClass( "alert-danger" );
                break;
            case 'information':
                this.$bar.addClass("alert-info");
                break;
            case 'notice':
                this.$bar.addClass("alert-success");
                break;
            case 'success':
                this.$bar.addClass( "alert-success" );
                break;
        }

        this.$message.css({
            padding: '8px 10px 9px',
            width: 'auto',
            position: 'relative'
        });
    },
    callback: {
        onShow: function() {  },
        onClose: function() {  }
    }
};

$.noty.defaults = {
    layout: 'topRight',
    theme: 'bootstrapTheme',
    type: 'alert',
    text: '', // can be html or string
    dismissQueue: true, // If you want to use queue feature set this true
    template: '<div class="noty_message"><div class="noty_close"></div><span class="noty_text"></span></div>',
    animation: {
        open: {height: 'toggle'},
        close: {height: 'toggle'},
        easing: 'swing',
        speed: 500 // opening & closing animation speed
    },
    timeout: 8000, // delay for closing event. Set false for sticky notifications
    force: false, // adds notification to the beginning of queue when set to true
    modal: false,
    maxVisible: 5, // you can set max visible notification for dismissQueue true option,
    killer: false, // for close all notifications before show
    closeWith: ['click', 'button'], // ['click', 'button', 'hover']
    callback: {
        onShow: function() {},
        afterShow: function() {},
        onClose: function() {},
        afterClose: function() {}
    },
    buttons: false // an array of buttons
};