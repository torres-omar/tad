$(window).on("load", function () {
    // subscribe to channel and bind to event
    let channel = pusher.subscribe('private-tad-channel');
    channel.bind('offer-created', function (data) {
        let update_notification = $('#update-notification');
        update_notification.removeClass('notification_container--hidden');
        setTimeout(function(){
            update_notification.addClass('notification_container--hidden');
        }, 3000);
    });
});
