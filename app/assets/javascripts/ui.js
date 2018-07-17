$(document).ready(function(){
    // disables closing of dropdown upon item clicking
    $('.dropdown-menu').on("click.bs.dropdown", function (e) { e.stopPropagation();});

    // add throtle
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
        gauge_a.css('width', gauge_a_width);
        gauge_a.css('height', gauge_a_height);
        gauge_a.css('border-top-left-radius', gauge_a_width);
        gauge_a.css('border-top-right-radius', gauge_a_width);
    }
});

