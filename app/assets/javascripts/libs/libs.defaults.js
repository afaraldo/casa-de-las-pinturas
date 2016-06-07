// confogurar datepicker para espanhol
$.fn.datepicker.defaults.language = 'es';
$.fn.datepicker.defaults.autoclose = true;
$.fn.datepicker.defaults.todayHighlight = true;
$.fn.datepicker.defaults.startDate = moment([1900]).toDate(); // Prevenir que se seleccione fecha cero