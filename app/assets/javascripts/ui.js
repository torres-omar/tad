$(document).ready(function(){
    // disables closing of dropdown upon item clicking
    $('.dropdown-menu').on("click.bs.dropdown", function (e) { e.stopPropagation();});

    // trigger event only when media query is matched, not every time screen is resized
    // let mql_sm = window.matchMedia('(max-width:  575.98px)');
    // let mql_seg_one = window.matchMedia('(min-width: 576px) and (max-width: 767.98px)');
    // let mql_seg_two = window.matchMedia('(min-width: 768px) and (max-width: 991.98px)');
    // let mql_seg_three = window.matchMedia('(min-width: 992px) and (max-width: 1199.98px)');
    // let mql_lgxl = window.matchMedia('(min-width: 1200px)');
    // mql_sm.addListener(handleMediaChange)
    // mql_seg_one.addListener(handleMediaChange)
    // mql_seg_two.addListener(handleMediaChange)
    // mql_seg_three.addListener(handleMediaChange)
    // mql_lgxl.addListener(handleMediaChange)
    // handleMediaChange(mql_lgxl)

    $(window).resize(handleMediaChange);
    function handleMediaChange(){
        let gauge_a = $('#gauge-a');
        let gauge_container_width = gauge_a.parent().width()
        let gauge_container_height = gauge_a.parent().height()
        let gauge_a_height = gauge_container_height 
        let gauge_a_width = (gauge_a_height / 2) * 3
        if(gauge_a_width > gauge_container_width){
            gauge_a_width = gauge_container_width
            gauge_a_height = (gauge_a_width / 3) * 2
        }
        debugger
        gauge_a.css('width', gauge_a_width);
        gauge_a.css('height', gauge_a_height);
        gauge_a.css('border-top-left-radius', gauge_a_width);
        gauge_a.css('border-top-right-radius', gauge_a_width);
    }
});

