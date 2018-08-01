$(window).on("load", function () {
    if( $('#dashboard_overview-tab').length > 0 ){
        // var OAR_months_years_graph_bubbles = $("#chart-status_offer-ratios .chart-status_bubble");
        var update_notification_bar = $('#update-notification');
        // subscribe to channel and bind to event
        var channel = pusher.subscribe('private-tad-channel');
        channel.bind('offer-created', function (data){
            $('#notification_message').text("An offer was created.");
            update_notification_bar.css("background-color", "#35A8D1");
            handleOfferEvent(data);
        });
        channel.bind('offer-deleted', function(data){
            $('#notification_message').text("An offer was deleted.");
            update_notification_bar.css("background-color", "#ff4339");
            handleOfferEvent(data);
        });
        channel.bind('offer-updated', function(data){
            $('#notification_message').text("An offer was updated.");
            update_notification_bar.css("background-color", "#F6CB25");
            handleOfferEvent(data);
        });
        // channel.bind('offer-rejected', function(data){
        //     $('#notification_message').text("An offer was rejected.");
        //     update_notification_bar.css("background-color", "red");
        //     handleOfferEvent(data);
        // });
        // channel.bind("offer-accepted", function(data){
        //     $('#notification_message').text("An offer was accepted!");
        //     handleOfferAcceptedEvent(data);
        //     // dont't show notification, since that's taken care of by the function above.
        //     handleOfferEvent(data, false);
        // })

        // function handleOfferAcceptedEvent(data, show_notification=true){
        //     if(show_notification){
        //         // show notification bar for x number of seconds
        //         update_notification_bar.removeClass('notification_container--hidden');
        //         setTimeout(function () {
        //             update_notification_bar.addClass("notification_container--hidden");
        //         }, 3000);
        //     }
        //     // update everything that is concerned with hires 
        //     // first up, years-months graph
        //     var operating_years = window.TADCharts.Hires.years_months_graph.data.map(function(e) { return e.name });
        //     if(operating_years.includes(data.created_year)){
        //         handleWebhookEventUpdateChart(graph, bubbles, params, url);
        //     }

        // }

        function handleOfferEvent(data, show_notification=true){
            if (show_notification) {
                // show notification bar for x number of seconds
                update_notification_bar.removeClass('notification_container--hidden');
                setTimeout(function () {
                    update_notification_bar.addClass("notification_container--hidden");
                }, 3000);
            }
            // check under what settings graph is operating in. 
            // if operating under a year that is similar to created_year within data arg, then update graph
            var operating_years = window.TADCharts.OAR.months_years_graph.data.map(function (e) { return e.name });
            // YEARS-MONTHS GRAPH
            if (operating_years.includes(data.created_year)) {
                var years_months_options = {
                    chart: window.TADCharts.OAR.months_years_graph,
                    params: $.param({ "years[]": operating_years }),
                    url: '/charts/overview/offer-acceptance-ratios?',
                    bubbles: $("#chart-status_offer-ratios .chart-status_bubble"),
                    type: 'Graph',
                    button: $("#offer-acceptance-ratios_submit")
                }
                handleWebhookEventUpdateChart(years_months_options);
            }
            // MONTH YEAR GAUGE
            // check to see if the date under which the gauge is operating in is similar to created_year and created_month
            var month_year_gauge = window.TADCharts.OAR.month_year_gauge;
            var month_year_gauge_date = month_year_gauge.date;
            if (month_year_gauge_date.data('month') == data.created_month && month_year_gauge_date.data('year') == data.created_year) {
                var month_year_gauge_options = {
                    chart: month_year_gauge, 
                    params: $.param({ month: month_year_gauge_date.data('month'), year: month_year_gauge_date.data('year') }), 
                    url: month_year_gauge.remote_url, 
                    bubbles: month_year_gauge.bubbles,
                    type: 'Gauge',
                    button: month_year_gauge.button
                }
                handleWebhookEventUpdateChart(month_year_gauge_options);
            }
            // YEAR GAUGE
            // check to see if the date under which the gauge is operating in is similar to created_year
            var year_gauge = window.TADCharts.OAR.year_gauge;
            var year_gauge_date = year_gauge.date.data('date');
            if (year_gauge_date == data.created_year) {
                var year_gauge_options = {
                    chart: year_gauge, 
                    params: $.param({ year: year_gauge_date }), 
                    url: year_gauge.remote_url, 
                    bubbles: year_gauge.bubbles,
                    type: 'Gauge',
                    button: year_gauge.button
                }
                handleWebhookEventUpdateChart(year_gauge_options);
            }
        }

        function handleWebhookEventUpdateChart(args){
            args.bubbles.addClass("chart-status_bubble--active");
            args.button.attr('disabled', 'true');
            $.ajax({
                method: 'GET', 
                url: `${args.url}${args.params}`, 
            }).then(function(response){
                setTimeout(function () {
                    switch(args.type){
                        case 'Gauge':
                            window.ChartsUtil.OAR.updateGauge(response, args.chart);
                            break;
                        case 'Graph':
                            args.chart.updateData(response);
                            break;
                    }
                    args.bubbles.removeClass("chart-status_bubble--active");
                    args.button.removeAttr('disabled');
                }, 2000);
            });
        }

        // function handleUpdateMonthsYearsGraph(params){
        //     // disable form 'apply' button
        //     // show loading bubbles
        //     OAR_months_years_graph_bubbles.addClass("chart-status_bubble--active");
        //     // make a new request to the same endpoint to update the graph, keeping the same internal settings (operating years)
        //     var params = $.param({ "years[]": params})
        //     $.ajax({
        //         method: 'GET',
        //         url: `/charts/overview/offer-acceptance-ratios?${params}`
        //     }).then(function (response) { updateOfferAcceptanceRatiosGraph(response) });
        // }

        // function handleUpdateGauge(gauge, params){
        //     // disable form 'apply' button
        //     // show loading bubbles
        //     gauge.bubbles.addClass("chart-status_bubble--active");
        //     // make a new request to the same endpoint to update the graph, keeping the same internal settings (operating years/months)
        //     $.ajax({
        //         method: 'GET',
        //         url: `${gauge.remote_url}${params}`
        //     }).then(function (response) { updateOARGauge(response, gauge) });
        // }

        // function updateOfferAcceptanceRatiosGraph(response) {
        //     // give animation some time to do its magic
        //     setTimeout(function () {
        //         window.TADCharts.OAR.months_years_graph.updateData(response);
        //         OAR_months_years_graph_bubbles.removeClass("chart-status_bubble--active");
        //     }, 2000);
        // }

        // function updateOARGauge(response, gauge) {
        //     // give animation some time to do its magic
        //     setTimeout(function () {
        //         window.ChartsUtil.OAR.updateGauge(response, gauge);
        //         gauge.bubbles.removeClass("chart-status_bubble--active");
        //     }, 2000);
        // }
    }
});
