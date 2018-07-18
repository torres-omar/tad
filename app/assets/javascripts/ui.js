$(document).ready(function(){
    // disables closing of dropdown upon item clicking
    $('.dropdown-menu').on("click.bs.dropdown", function (e) { e.stopPropagation();});

    // select gauge components to resize
    let gauge_outer = $('.gauge-outer');
    let gauge_inner = $('#gauge-inner');
    let gauge_outer_under = $('#gauge-outer-under');
    let gauge_outer_over = $('#gauge-outer-over');
    let gauge_container = $('.gauge-container');

    // fixes small issue with gauge overflowing when sidebar appears
    let mql = window.matchMedia('(min-width: 768px)');
    mql.addListener(handleMediaChange);
    function handleMediaChange(mql){
        if(mql.matches){
            updateGauge()
        }
    }

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
        gauge_inner.css('border-top-left-radius', gauge_outer_width);
        gauge_inner.css('border-top-right-radius', gauge_outer_width);
        gauge_inner.css('top', gauge_outer_height * 0.375);
    }

    // call updateGauge once content is loaded
    updateGauge();
    // listener for when screen size changes
    $(window).resize(throttleUpdateGauge(updateGauge, 2000));
    // initial gauge ratio display 
    let initial_ratio = gauge_outer_over.data('ratio');
    gauge_outer_over.css('transform', `rotate(${.5*initial_ratio}turn)`);
});

