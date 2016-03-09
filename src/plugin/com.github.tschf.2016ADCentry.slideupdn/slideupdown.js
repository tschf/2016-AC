var slideupdown = {

    duration: 800,

    slideUp: function slideUp(upSelector, completeCallback) {
        $(upSelector).slideUp({
            duration: this.duration,
            complete: completeCallback
        });
    },

    slideDown: function slideDown(downSelector){
        $(downSelector).slideDown({
            duration: this.duration
        })
    }

}
