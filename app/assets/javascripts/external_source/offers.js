$(window).on("load", function () {
    let offer_acceptance_ratios_graph = Chartkick.charts["offer-acceptance-ratios-graph"];
    let offer_acceptance_ratios_bubbles = $("#chart-status_offer-ratios .chart-status_bubble");
    let update_notification_bar = $('#update-notification');
    // subscribe to channel and bind to event
    let channel = pusher.subscribe('private-tad-channel');
    channel.bind('offer-created', (data) => {
        if(offer_acceptance_ratios_graph){
            // check under what settings graph is operating in. 
            // if operating under a year that is similar to created_year within data, then update graph
            let operating_years = offer_acceptance_ratios_graph.data.map(e => e.name);
            let update_years_months_graph = operating_years.includes(data.created_year);
            if(update_years_months_graph){
                // show notification bar
                update_notification_bar.removeClass('notification_container--hidden');
                // disable form 'apply' button

                // show loading bubbles
                offer_acceptance_ratios_bubbles.addClass("chart-status_bubble--active");
                // make a new request to the same endpoint to update the graph, keeping the same internal settings (operating years)
                let data = $.param({"years[]": operating_years})
                $.ajax({
                    method: 'GET',
                    url: `/charts/overview/offer-acceptance-ratios?${data}`
                }).then((response) => updateOfferAcceptanceRatiosGraph(response));
            }
        }
    });

    function updateOfferAcceptanceRatiosGraph(response){
        setTimeout(() => {
            offer_acceptance_ratios_graph.updateData(response);
            offer_acceptance_ratios_bubbles.removeClass("chart-status_bubble--active");
            update_notification_bar.addClass("notification_container--hidden");
        }, 3000);
    }
});
