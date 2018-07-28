$(window).on("load", function () {
    // subscribe to channel and bind to event
    let channel = pusher.subscribe('private-tad-channel');
    channel.bind('offer-created', function (data) {
        // show notification bar
        let update_notification = $('#update-notification');
        update_notification.removeClass('notification_container--hidden');

        // check under what settings each graph is operating in. 
        // if operating under a year that is similar to the data coming in, then update graph
        let years_hires_months_graph = Chartkick.charts["years-months-hires-graph"]
        update_years_hires_months_graph = false
        for(let i = 0; i < years_hires_months_graph.data.length; i++){
            if(years_hires_months_graph.data[i].name == data['created_year']){ 
                update_years_hires_months_graph = true; 
                break;
            }
        }

        // make a new request to the same endpoint to update the graph, keeping the same internal settings (operating years) 
        // $.param({ "years[]": [1, 3] })
        $.ajax({
            method: 'GET',
            url: `${gauge['remote_url']}${data}`
        }).then((response) => updateGauge(response, gauge));

        // if settings are displaying a graph that is concerned with cache change, 
        // then disable apply button, show loading bubbles, and update graph
        setTimeout(function(){
            update_notification.addClass('notification_container--hidden');
        }, 3000);
    });
});
