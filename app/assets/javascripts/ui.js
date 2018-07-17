$(document).ready(function(){
    // disables closing of dropdown upon item clicking
    $('.dropdown-menu').on("click.bs.dropdown", function (e) { e.stopPropagation();});
    updateGauge();
    // add throtle
    $(window).resize(updateGauge);
    function updateGauge(){
        // gauge-inner, 0.625 of gauge-outer
        let gauge_outer = $('.gauge-outer');
        let gauge_inner = $('#gauge-inner');
        let gauge_outer_under = $('#gauge-outer-under');
        let gauge_outer_over = $('#gauge-outer-over');
        let gauge_container = $('.gauge-container');
        gauge_container.css('min-height', '7rem');
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
});

