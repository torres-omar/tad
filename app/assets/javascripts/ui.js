$(document).ready(function(){
    // disables closing of dropdown upon item clicking
    $('.dropdown-menu').on("click.bs.dropdown", function (e) { e.stopPropagation();});

    // enable tootips
    $('[data-toggle="tooltip"]').tooltip()

    // mobile menu button toggle animation
    $('#menu_toggle-mobile-menu-button').click(function(){
        if ($('#menu_toggle-mobile-menu-button').data('closed')){
            $('#menu_toggle-mobile-menu-button').css('transform', 'rotate(180deg)')
            $('#menu_toggle-mobile-menu-button').data('closed', 0)
        }else{
            $('#menu_toggle-mobile-menu-button').css('transform', 'rotate(0deg)')
            $('#menu_toggle-mobile-menu-button').data('closed', 1)
        }
    })
});

