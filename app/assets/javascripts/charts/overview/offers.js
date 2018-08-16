$(document).ready(function () {
    // ----- IF ON OVERVIEW TAB ----
    if ($('#dashboard_overview-tab').length > 0){
        // ------- UTILITY FUNCTIONS ---------
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

        // ---- SELECT ELEMENTS ----------
        var months_years_graph = Chartkick.charts["offer-acceptance-ratios-graph"];
        var oar_month_year_gauge = {
            gauge_outer_over: $('#gauge-outer-over_year-month'),
            gauge_data: $('#gauge-data_year-month'),
            offers_sent: $('#offer-acceptance-ratio_year-month--offers-sent'),
            offers_accepted: $('#offer-acceptance-ratio_year-month--offers-accepted'),
            date: $('#offer-acceptance-ratio_date'),
            form: $('#month-year-offer-acceptance-ratio_form'),
            remote_url: '/charts/overview/month-year-offer-acceptance-ratio?',
            bubbles: $('#chart-status_offer-ratio-month-year .chart-status_bubble'),
            button: $("#month-year-offer-acceptance-ratio_submit")
        }
        var oar_year_gauge = {
            gauge_outer_over: $('#gauge-outer-over_year'),
            gauge_data: $('#gauge-data_year'),
            offers_sent: $('#offer-acceptance-ratio_year--offers-sent'),
            offers_accepted: $('#offer-acceptance-ratio_year--offers-accepted'),
            date: $('#offer-acceptance-ratio_year'),
            form: $('#year-offer-acceptance-ratio_form'),
            remote_url: '/charts/overview/year-offer-acceptance-ratio?',
            bubbles: $('#chart-status_offer-ratio-year .chart-status_bubble'),
            button: $("#year-offer-acceptance-ratio_submit")
        }

        // when offer acceptance ratios graph settings are changed 
        $('#offer-acceptance-ratios_submit').click(function (event) {
            event.preventDefault();
            var data = $('#offer-acceptance-ratios_form').serialize();
            months_years_graph.updateData(`/charts/overview/offer-acceptance-ratios?${data}`);
        });
    
        // event handler
        function handleSubmitButtonClicked(event, gauge){
            event.preventDefault();
            var data = gauge['form'].serialize();
            $.ajax({
                method: 'GET',
                url: `${gauge['remote_url']}${data}`
            }).then(function(response){ updateGauge(response, gauge) });
        }
    
        // when gauge settings are changes
        $('#month-year-offer-acceptance-ratio_submit').click(function(event){
            handleSubmitButtonClicked(event, oar_month_year_gauge);
        });
    
        $('#year-offer-acceptance-ratio_submit').click(function(event){
            handleSubmitButtonClicked(event, oar_year_gauge);
        });
    }
});
