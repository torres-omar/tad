$(document).ready(function(){
    // disables closing of dropdown upon item clicking
    $('.dropdown-menu').on("click.bs.dropdown", function (e) { e.stopPropagation();});
});

