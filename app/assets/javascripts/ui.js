$(document).ready(function(){
    // disables closing of dropdown upon item clicking
    $('.dropdown-menu').on("click.bs.dropdown", function (e) { e.stopPropagation();});

    // trigger event only when media query is matches, not every time screen is resized
    let mql_sm = window.matchMedia('(max-width:  575.98px)');
    let mql_seg_one = window.matchMedia('(min-width: 576px) and (max-width: 767.98px)');
    let mql_seg_two = window.matchMedia('(min-width: 768px) and (max-width: 991.98px)');
    let mql_seg_three = window.matchMedia('(min-width: 992px) and (max-width: 1199.98px)');
    let mql_lgxl = window.matchMedia('(min-width: 1200px)');
    mql_sm.addListener(handleMediaChange)
    mql_seg_one.addListener(handleMediaChange)
    mql_seg_two.addListener(handleMediaChange)
    mql_seg_three.addListener(handleMediaChange)
    handleMediaChange(mql_lgxl)

    function handleMediaChange(mql){
        if(mql.matches){
            $()
        }
    }
});

