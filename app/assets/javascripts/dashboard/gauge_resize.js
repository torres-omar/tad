$(document).ready(function () {
    // select gauge components to resize
    var gauge_outer = $('.gauge_outer');
    var gauge_inner = $('.gauge_inner');
    var gauge_outer_under = $('.gauge_outer-under');
    var gauge_outer_over = $('.gauge_outer-over');
    var gauge_container = $('.gauge_container');
    var gauge_data = $('.gauge_data');

    // function that throttles updateGauge function 
    // makes sure to call function only when event has stopped.
    // also makes sure to space successive calls by a given 'time limit'
    function throttleUpdateGauge(func, limit){
        var lastRunTime;
        var lastFunctionCalled;
        return function () {
            // first call
            if (!lastRunTime) {
                func.apply(null)
                lastRunTime = Date.now()
            } else {
                clearInterval(lastFunctionCalled)
                lastFunctionCalled = setTimeout(function(){
                    // throttlings
                    if ((Date.now() - lastRunTime) >= limit) {
                        func.apply(null)
                        lastRunTime = Date.now()
                    }
                }, limit - (Date.now() - lastRunTime))
            }
        }
    }

    // maintains gauge size and positioning ratios when screen size changes
    function updateGauge(){
        console.log('updating..')
        gauge_container.css('min-height', '6rem');
        var gauge_container_width = gauge_container.width();
        var gauge_container_height = gauge_container.height();
        var gauge_outer_height = gauge_container_height;
        var gauge_outer_width = (gauge_outer_height * 2);
        if (gauge_outer_width > gauge_container_width) {
            gauge_outer_width = gauge_container_width
            gauge_outer_height = (gauge_outer_width / 2);
            gauge_container.css('min-height', gauge_outer_height);
        }
        gauge_outer.css('width', gauge_outer_width);
        gauge_outer.css('height', gauge_outer_height);
        gauge_inner.css('width', gauge_outer_width * 0.625);
        gauge_inner.css('height', gauge_outer_height * 0.625);
        gauge_outer_under.css('border-top-left-radius', gauge_outer_width);
        gauge_outer_under.css('border-top-right-radius', gauge_outer_width);
        gauge_outer_over.css('border-bottom-left-radius', gauge_outer_width);
        gauge_outer_over.css('border-bottom-right-radius', gauge_outer_width);
        gauge_outer_over.css('top', gauge_outer_height);
        gauge_data.css('width', gauge_outer_width);
        gauge_data.css('height', gauge_outer_height);
        gauge_data.css('top', gauge_outer_height * 0.60);
        gauge_inner.css('border-top-left-radius', gauge_outer_width);
        gauge_inner.css('border-top-right-radius', gauge_outer_width);
        gauge_inner.css('top', gauge_outer_height * 0.375);
    }

    // call updateGauge once content is loaded
    updateGauge();
    // listener for when screen size changes
    $(window).resize(throttleUpdateGauge(updateGauge, 2000));
});
