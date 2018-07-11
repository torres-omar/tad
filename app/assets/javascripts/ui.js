$(document).ready(function(){
    // disables closing of dropdown upon item clicking
    $('.dropdown-menu').on("click.bs.dropdown", function (e) { e.stopPropagation();});

    Pusher.logToConsole = true;

    var pusher = new Pusher('eda2463af9ba8324c4ee', {
        cluster: 'us2',
        encrypted: true
    });

    var channel = pusher.subscribe('my-channel');
    channel.bind('my-event', function (data) {
        alert(JSON.stringify(data));
    });
});

