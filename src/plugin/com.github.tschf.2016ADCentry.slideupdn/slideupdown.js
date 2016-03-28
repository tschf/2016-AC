var slideupdown = {

    slideUp: function slideUp(upSelector, duration, completeCallback) {
        $(upSelector).slideUp({
            duration: duration,
            complete: completeCallback
        });
    },

    slideDown: function slideDown(downSelector, duration){
        $(downSelector).slideDown({
            duration: duration
        });
    }

}
