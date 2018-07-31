$(window).on("load", function () {
    if( $('#dashboard_overview-tab').length > 0 ){
        var OAR_months_years_graph_bubbles = $("#chart-status_offer-ratios .chart-status_bubble");
        var update_notification_bar = $('#update-notification');
        // subscribe to channel and bind to event
        var channel = pusher.subscribe('private-tad-channel');
        channel.bind('offer-created', function (data){
            $('#notification_message').text("An offer was created");
            handleOfferEvent(data);
        });
        channel.bind('offer-deleted', function(data){
            $('#notification_message').text("An offer was deleted");
            update_notification_bar.css("background-color", "#ff4339");
            handleOfferEvent(data);
        })

        function handleOfferEvent(data){
            // show notification bar for x number of seconds
            update_notification_bar.removeClass('notification_container--hidden');
            setTimeout(function () {
                update_notification_bar.addClass("notification_container--hidden");
            }, 3000);
            // check under what settings graph is operating in. 
            // if operating under a year that is similar to created_year within data arg, then update graph
            var operating_years = window.TADCharts.OAR.months_years_graph.data.map(function (e) { return e.name });
            var update_months_years_graph = operating_years.includes(data.created_year);
            // YEARS-MONTHS GRAPH
            if (update_months_years_graph) {
                handleUpdateMonthsYearsGraph(operating_years);
            }
            // MONTH YEAR GAUGE
            // check to see if the date under which the gauge is operating in is similar to created_year and created_month
            var month_year_gauge = window.TADCharts.OAR.month_year_gauge;
            var month_year_gauge_date = month_year_gauge.date;
            if (month_year_gauge_date.data('month') == data.created_month && month_year_gauge_date.data('year') == data.created_year) {
                var month_year_params = $.param({ month: month_year_gauge_date.data('month'), year: month_year_gauge_date.data('year') });
                handleUpdateGauge(month_year_gauge, month_year_params);
            }
            // YEAR GAUGE
            // check to see if the date under which the gauge is operating in is similar to created_year
            var year_gauge = window.TADCharts.OAR.year_gauge;
            var year_gauge_date = year_gauge.date;
            if (year_gauge_date.data('date') == data.created_year) {
                var year_params = $.param({ year: year_gauge_date.data('date') });
                handleUpdateGauge(year_gauge, year_params);
            }
        }

        function handleUpdateMonthsYearsGraph(params){
            // disable form 'apply' button
            // show loading bubbles
            OAR_months_years_graph_bubbles.addClass("chart-status_bubble--active");
            // make a new request to the same endpoint to update the graph, keeping the same internal settings (operating years)
            var params = $.param({ "years[]": params})
            $.ajax({
                method: 'GET',
                url: `/charts/overview/offer-acceptance-ratios?${params}`
            }).then(function (response) { updateOfferAcceptanceRatiosGraph(response) });
        }

        function handleUpdateGauge(gauge, params){
            // disable form 'apply' button
            // show loading bubbles
            gauge.bubbles.addClass("chart-status_bubble--active");
            // make a new request to the same endpoint to update the graph, keeping the same internal settings (operating years/months)
            $.ajax({
                method: 'GET',
                url: `${gauge.remote_url}${params}`
            }).then(function (response) { updateOARGauge(response, gauge) });
        }

        function updateOfferAcceptanceRatiosGraph(response) {
            // give animation some time to do its magic
            setTimeout(function () {
                window.TADCharts.OAR.months_years_graph.updateData(response);
                OAR_months_years_graph_bubbles.removeClass("chart-status_bubble--active");
            }, 1000);
        }

        function updateOARGauge(response, gauge) {
            // give animation some time to do its magic
            setTimeout(function () {
                window.ChartsUtil.OAR.updateGauge(response, gauge);
                gauge.bubbles.removeClass("chart-status_bubble--active");
            }, 1000);
        }
    }
});
