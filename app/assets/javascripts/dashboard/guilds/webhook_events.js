$(window).on("load", function () {
    // if ($('#dashboard_guilds-tab').length > 0) {
    //     var update_notification_bar = $('#update-notification');
    //     // subscribe to channel and bind to event
    //     var channel = pusher.subscribe('private-tad-channel');
    //     channel.bind("offer-accepted", function (data) {
    //         $('#notification_message').text("An offer was accepted!");
    //         update_notification_bar.css("background-color", "#FF6C36");
    //         handleOfferAcceptedEvent(data);
    //     })

    //     function handleOfferAcceptedEvent(data) {
    //         // show notification bar for x number of seconds
    //         update_notification_bar.removeClass('notification_container--hidden');
    //         setTimeout(function () {
    //             update_notification_bar.addClass("notification_container--hidden");
    //         }, 3000);
    //         // update hires by guild graph
    //         var hires_by_guild_graph = window.TADCharts.Hires.hires_by_guild_graph;
    //         var hires_by_guild_operating_year = $('#hires-by-guild_year').data('date');
    //         if (hires_by_guild_operating_year == data.created_year) {
    //             var hires_by_guild_options = {
    //                 chart: hires_by_guild_graph,
    //                 params: $.param({ "year": hires_by_guild_operating_year }),
    //                 url: '/charts/guilds/hires-by-guild-for-year?',
    //                 bubbles: $("#chart-status_hires-by-guild .chart-status_bubble"),
    //                 type: 'Graph',
    //                 button: $("#hires-by-guild_submit")
    //             }
    //             window.ChartsUtil.Shared.handleWebhookEventUpdateChart(hires_by_guild_options);
    //         }
    //     }
    // }
});
