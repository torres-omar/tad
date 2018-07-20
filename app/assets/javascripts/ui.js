$(document).ready(function(){
    // disables closing of dropdown upon item clicking
    $('.dropdown-menu').on("click.bs.dropdown", function (e) { e.stopPropagation();});

    // select gauge components to resize
    let gauge_outer = $('.gauge-outer');
    let gauge_inner = $('.gauge-inner');
    let gauge_outer_under = $('.gauge-outer-under');
    let gauge_outer_over = $('.gauge-outer-over');
    let gauge_container = $('.gauge-container');
    let gauge_data = $('.gauge-data');
    let gauge_outer_over_year_month = $('#gauge-outer-over_year-month');
    let gauge_outer_over_year = $('#gauge-outer-over_year');

    // function that throttles updateGauge function (limit the number of times it is called) 
    const throttleUpdateGauge = (func, limit) => {
        let lastRunTime;
        let lastFunctionCalled;
        return function () {
            // first call
            if (!lastRunTime) {
                func.apply(null)
                lastRunTime = Date.now()
            } else {
                clearInterval(lastFunctionCalled)
                // throttling 
                lastFunctionCalled = setTimeout(function () {
                    if ((Date.now() - lastRunTime) >= limit) {
                        func.apply(null)
                        lastRunTime = Date.now()
                    }
                }, limit - (Date.now() - lastRunTime))
            }
        }
    }
    
    // maintains gauge size and positioning ratios when screen size changes
    const updateGauge = () => {
        gauge_container.css('min-height', '6rem');
        let gauge_container_width = gauge_container.width();
        let gauge_container_height = gauge_container.height();
        let gauge_outer_height = gauge_container_height;
        let gauge_outer_width = (gauge_outer_height * 2);
        if(gauge_outer_width > gauge_container_width){
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
    // initial gauge ratios display 
    let initial_ratio_year_month = gauge_outer_over_year_month.data('ratio');
    let initial_ratio_year = gauge_outer_over_year.data('ratio')
    gauge_outer_over_year_month.css('transform', `rotate(${.5*initial_ratio_year_month}turn)`);
    gauge_outer_over_year.css('transform', `rotate(${.5*initial_ratio_year}turn)`);

});

