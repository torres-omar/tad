$(window).on("load", function () {
    // ---------------------- DEFINE UTILITY FUNCTIONS  -----------------------
    function updateGauge(response, gauge) {
        var percent_turn = response['ratio'] == 1 ? 0.5 : 0.5 * response['ratio'];
        gauge['gauge_outer_over'].css('transform', `rotate(${percent_turn}turn`);
        gauge['gauge_data'].text(response['ratio']);
        gauge['offers_sent'].text(response['offers']);
        gauge['offers_accepted'].text(response['accepted_offers']);
        gauge['date'].text(response['date']);
        gauge['date'].data('date', response['date']);
        if (response['month'] && response['year']) {
            gauge['date'].data("year", response['year']);
            gauge['date'].data("month", response['month']);
        }
    }

    function updateStatistics(response) {
        $('#hires-stats_date').text(response['date']);
        $('#hires-stats_date').data('date', response['date']);
        $('#hires-stats_average').text(response['average']);
        $('#hires-stats_median').text(response['median']);
    }

    function updateRecentHires(response) {
        if ($($('.recent-hire_info-container').first()).data('candidate-id') != response['candidate_id']) {
            $($('.recent-hire_info-container').last()).remove();
            var new_row = $('<div/>', { 'class': 'table_date-container mb-1', 'data-candidate-id': `${response['candidate_id']}` }).append(
                $('<div/>', { 'class': 'container-fluid' }).append(
                    $('<div/>', { 'class': 'row' }).append(
                        $('<div/>', { 'class': "col-md-1 col-lg-1 d-flex align-items-center justify-content-center table_data--sm-display" }).append(
                            $('<i/>', { 'class': "material-icons table_data-icon table_data--sm-display", 'text': 'perm_identity' })
                        )
                    ).append(
                        $('<div/>', { 'class': "col-6 col-md-4 col-lg-3 d-flex align-items-center" }).append(
                            $('<p/>', { 'class': "table_data-text", 'text': `${response['hire_name']}` })
                        )
                    ).append(
                        $('<div/>', { 'class': "col-6 col-md-4 col-lg-3 d-flex align-items-center" }).append(
                            $('<p/>', { 'class': "table_data-text", 'text': `${response['job']}` })
                        )
                    ).append(
                        $('<div/>', { 'class': "col-md-3 col-lg-3 d-flex align-items-center table_data--sm-display" }).append(
                            $('<p/>', { 'class': "table_data-text table_data--sm-display", 'text': `${response['guild']}` })
                        )
                    ).append(
                        $('<div/>', { 'class': "col-lg-2 d-flex align-items-center table_data--lg-display" }).append(
                            $('<p/>', { 'class': "table_data-text table_data--lg-display", 'text': `${response['hire_date']}` })
                        )
                    )
                )
            )
            $('#recent-hires_rows').prepend(new_row);
        }
    }

    function handleWebhookEventUpdateChart(args) {
        args.bubbles.addClass("chart_status-bubble--active");
        if (args.button) { args.button.attr('disabled', 'true'); }
        $.ajax({
            method: 'GET',
            url: `${args.url}${args.params}`,
        }).then(function (response) {
            setTimeout(function () {
                switch (args.type) {
                    case 'Gauge':
                        updateGauge(response, args.chart);
                        break;
                    case 'Graph':
                        args.chart.updateData(response);
                        break;
                    case 'Hires-stats':
                        updateStatistics(response);
                        break;
                    case 'Recent-hires':
                        updateRecentHires(response);
                        break;
                }
                args.bubbles.removeClass("chart_status-bubble--active");
                if (args.button) { args.button.removeAttr('disabled'); }
            }, 2000);
        });
    }

    // -------------- IF ON OVERVIEW TAB -------------------
    if( $('#dashboard_overview-tab').length > 0 ){
        // ------------------- SELECT ELEMENTS -------------------
        var hires_year_by_year_graph = Chartkick.charts["years-hires-graph"];
        var hires_years_months_graph = Chartkick.charts["years-months-hires-graph"];
        var hires_stats = {
            date: $('#hires-stats_date'),
            form: $('#hires-stats_form'),
            average: $('#hires-stats_average'),
            median: $('#hires-stats_median'),
            remote_url: '/charts/overview/hires-statistics?',
            bubbles: $('#chart-status_hires-stats'),
            button: $('#hires-stats_submit')
        };
        var recent_hires = {
            rows_container: $('#recent-hires_rows'),
            bubbles: $("#chart-status_recent-hires .chart-status_bubble"),
            remote_url: '/charts/overview/most-recent-hire'
        };
        var oar_years_months_graph = Chartkick.charts["offer-acceptance-ratios-graph"];
        var oar_month_year_gauge = {
            gauge_outer_over: $('#gauge-outer-over_year-month'),
            gauge_data: $('#gauge-data_year-month'),
            offers_sent: $('#offer-acceptance-ratio_year-month--offers-sent'),
            offers_accepted: $('#offer-acceptance-ratio_year-month--offers-accepted'),
            date: $('#offer-acceptance-ratio_date'),
            form: $('#month-year-offer-acceptance-ratio_form'),
            remote_url: '/charts/overview/month-year-offer-acceptance-ratio?',
            bubbles: $('#chart-status_offer-ratio-month-year .chart_status-bubble'),
            button: $("#month-year-offer-acceptance-ratio_submit")
        };
        var oar_year_gauge = {
            gauge_outer_over: $('#gauge-outer-over_year'),
            gauge_data: $('#gauge-data_year'),
            offers_sent: $('#offer-acceptance-ratio_year--offers-sent'),
            offers_accepted: $('#offer-acceptance-ratio_year--offers-accepted'),
            date: $('#offer-acceptance-ratio_year'),
            form: $('#year-offer-acceptance-ratio_form'),
            remote_url: '/charts/overview/year-offer-acceptance-ratio?',
            bubbles: $('#chart-status_offer-ratio-year .chart_status-bubble'),
            button: $("#year-offer-acceptance-ratio_submit")
        };
        var update_notification_bar = $('#update-notification');


        // ----------- SUBSCRIBE TO CHANNEL AND BIND TO EVENTS -------------
        var channel = pusher.subscribe('private-tad-channel');
        channel.bind('offer-created', function (data){
            $('#notification_message').text("An offer was created.");
            update_notification_bar.css("background-color", "#35A8D1");
            handleOfferEvent(data);
        });
        channel.bind('offer-deleted', function(data){
            $('#notification_message').text("An offer was deleted.");
            update_notification_bar.css("background-color", "#512C81");
            handleOfferEvent(data);
        });
        channel.bind('offer-updated', function(data){
            $('#notification_message').text("An offer was updated.");
            update_notification_bar.css("background-color", "#F6CB25");
            handleOfferEvent(data);
        });
        channel.bind('offer-rejected', function(data){
            $('#notification_message').text("An offer was rejected.");
            update_notification_bar.css("background-color", "#CB2B99");
            handleOfferEvent(data);
        });
        channel.bind("offer-accepted", function(data){
            $('#notification_message').text("An offer was accepted!");
            update_notification_bar.css("background-color", "#FF6C36");
            handleOfferAcceptedEvent(data);
            // dont't show notification, since that's taken care of by the function above.
            handleOfferEvent(data, false);
        })

        // ------ DEFINE EVENT HANDLERS -----------
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
            var years_months_operating_years = hires_years_months_graph.data.map(function(e) { return e.name });
            if(years_months_operating_years.includes(data.created_year)){
                var years_months_options = {
                    chart: hires_years_months_graph,
                    params: $.param({ "years[]": years_months_operating_years }),
                    url: '/charts/overview/new-hires-years-months?',
                    bubbles: $("#chart-status_hires-years-months .chart-status_bubble"),
                    type: 'Graph',
                    button: $("#years-months-hires_submit")
                }
                handleWebhookEventUpdateChart(years_months_options);
            }

            // YEARS GRAPH
            var years_operating_years = hires_year_by_year_graph.rawData.map(function (e) { return e[0] })
            if(years_months_operating_years.includes(data.created_year)){
                var years_options = {
                    chart: hires_year_by_year_graph,
                    params: $.param({ "years[]": years_operating_years }),
                    url: '/charts/overview/new-hires-years?',
                    bubbles: $("#chart-status_hires-years .chart-status_bubble"),
                    type: 'Graph',
                    button: $("#years-hires_submit")
                }
                handleWebhookEventUpdateChart(years_options);
            }

            // HIRES STATS
            var hires_stats_date = hires_stats.date.data('date');
            if ( hires_stats_date == data.created_year){
                var hires_stats_options = {
                    chart: hires_stats,
                    params: $.param({year: hires_stats_date}),
                    url: hires_stats.remote_url,
                    bubbles: hires_stats.bubbles, 
                    type: 'Hires-stats',
                    button: hires_stats.button
                }
                handleWebhookEventUpdateChart(hires_stats_options);
            }

            // RECENT HIRES TABLE
            var recent_hires_options = {
                chart: recent_hires, 
                url: recent_hires.remote_url,
                params: '', 
                bubbles: recent_hires.bubbles, 
                type: 'Recent-hires'
            }
            handleWebhookEventUpdateChart(recent_hires_options);
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
            var operating_years = oar_years_months_graph.data.map(function (e) { return e.name });
            // YEARS-MONTHS GRAPH
            if (operating_years.includes(data.created_year)) {
                var months_years_options = {
                    chart: oar_years_months_graph,
                    params: $.param({ "years[]": operating_years }),
                    url: '/charts/overview/offer-acceptance-ratios?',
                    bubbles: $("#chart-status_offer-ratios .chart_status-bubble"),
                    type: 'Graph',
                    button: $("#offer-acceptance-ratios_submit")
                }
                handleWebhookEventUpdateChart(months_years_options);
            }
            // MONTH YEAR GAUGE
            // check to see if the date under which the gauge is operating in is similar to created_year and created_month
            var oar_month_year_gauge_date = oar_month_year_gauge.date;
            if (oar_month_year_gauge_date.data('month') == data.created_month && oar_month_year_gauge_date.data('year') == data.created_year) {
                var oar_month_year_gauge_options = {
                    chart: oar_month_year_gauge, 
                    params: $.param({ month: oar_month_year_gauge_date.data('month'), year: oar_month_year_gauge_date.data('year') }), 
                    url: oar_month_year_gauge.remote_url, 
                    bubbles: oar_month_year_gauge.bubbles,
                    type: 'Gauge',
                    button: oar_month_year_gauge.button
                }
                handleWebhookEventUpdateChart(oar_month_year_gauge_options);
            }
            // YEAR GAUGE
            // check to see if the date under which the gauge is operating in is similar to created_year
            var oar_year_gauge_date = oar_year_gauge.date.data('date');
            if (oar_year_gauge_date == data.created_year) {
                var oar_year_gauge_options = {
                    chart: oar_year_gauge, 
                    params: $.param({ year: oar_year_gauge_date }), 
                    url: oar_year_gauge.remote_url, 
                    bubbles: oar_year_gauge.bubbles,
                    type: 'Gauge',
                    button: oar_year_gauge.button
                }
                handleWebhookEventUpdateChart(oar_year_gauge_options);
            }
        }
    }
});
