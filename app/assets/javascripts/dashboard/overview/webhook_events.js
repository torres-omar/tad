$(window).on("load", function () {
    if( $('#dashboard_overview-tab').length > 0 ){
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
        channel.bind('offer-rejected', function(data){
            $('#notification_message').text("An offer was rejected.");
            update_notification_bar.css("background-color", "red");
            handleOfferEvent(data);
        });
        channel.bind("offer-accepted", function(data){
            $('#notification_message').text("An offer was accepted!");
            handleOfferAcceptedEvent(data);
            // dont't show notification, since that's taken care of by the function above.
            handleOfferEvent(data, false);
        })

        function handleOfferAcceptedEvent(data, show_notification=true){
            if(show_notification){
                // show notification bar for x number of seconds
                update_notification_bar.removeClass('notification_container--hidden');
                setTimeout(function () {
                    update_notification_bar.addClass("notification_container--hidden");
                }, 3000);
            }
            // update everything that is concerned with hires 
            // first up, YEAR_MONTHS GRAPH
            var years_months_graph = window.TADCharts.Hires.years_months_graph;
            var years_months_operating_years = years_months_graph.data.map(function(e) { return e.name });
            if(years_months_operating_years.includes(data.created_year)){
                var years_months_options = {
                    chart: years_months_graph,
                    params: $.param({ "years[]": years_months_operating_years }),
                    url: '/charts/overview/new-hires-years-months?',
                    bubbles: $("#chart-status_hires-years-months .chart-status_bubble"),
                    type: 'Graph',
                    button: $("#years-months-hires_submit")
                }
                handleWebhookEventUpdateChart(years_months_options);
            }

            // YEARS GRAPH
            var years_graph = window.TADCharts.Hires.year_by_year_graph;
            var years_operating_years = years_graph.data.map(function(e) { return e.name });
            if(years_months_operating_years.includes(data.created_year)){
                var years_options = {
                    chart: years_graph,
                    params: $.param({ "years[]": years_operating_years }),
                    url: '/charts/overview/new-hires-years?',
                    bubbles: $("#chart-status_hires-years .chart-status_bubble"),
                    type: 'Graph',
                    button: $("#years-hires_submit")
                }
                handleWebhookEventUpdateChart(years_options);
            }

            // HIRES STATS
            var hires_stats_chart = window.TADCharts.Hires.hires_stats;
            var hires_stats_date = hires_stats_chart.date.data('date');
            if ( hires_stats_date == data.created_year){
                var hires_stats_options = {
                    chart: hires_stats_chart,
                    params: $.param({year: hires_stats_date}),
                    url: hires_stats_chart.remote_url,
                    bubbles: hires_stats_chart.bubbles, 
                    type: 'Hires-stats',
                    button: hires_stats_chart.button
                }
                handleWebhookEventUpdateChart(hires_stats_options);
            }

            // RECENT HIRES TABLE
            
        }

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
            var months_years_graph = window.TADCharts.OAR.months_years_graph;
            var operating_years = months_years_graph.data.map(function (e) { return e.name });
            // YEARS-MONTHS GRAPH
            if (operating_years.includes(data.created_year)) {
                var months_years_options = {
                    chart: months_years_graph,
                    params: $.param({ "years[]": operating_years }),
                    url: '/charts/overview/offer-acceptance-ratios?',
                    bubbles: $("#chart-status_offer-ratios .chart-status_bubble"),
                    type: 'Graph',
                    button: $("#offer-acceptance-ratios_submit")
                }
                handleWebhookEventUpdateChart(months_years_options);
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
                        case 'Hires-stats': 
                            window.ChartsUtil.Hires.updateStatistics(response);
                            break;
                    }
                    args.bubbles.removeClass("chart-status_bubble--active");
                    args.button.removeAttr('disabled');
                }, 2000);
            });
        }
    }
});
