$(document).ready(function () {
    // graph
    let chart = Chartkick.charts["offer-acceptance-ratios-graph"]
    // year_month gauge
    let gauge_for_month_year = {
        gauge_outer_over: $('#gauge-outer-over_year-month'), 
        gauge_data: $('#gauge-data_year-month'), 
        offers_sent: $('#offer-acceptance-ratio_year-month--offers-sent'), 
        offers_accepted: $('#offer-acceptance-ratio_year-month--offers-accepted'), 
        date: $('#offer-acceptance-ratio_date'),
        form: $('#month-year-offer-acceptance-ratio_form'),
        remote_url: '/charts/overview/month-year-offer-acceptance-ratio?'
    }
    // year gauge
    let gauge_for_year = {
        gauge_outer_over: $('#gauge-outer-over_year'),
        gauge_data: $('#gauge-data_year'),
        offers_sent: $('#offer-acceptance-ratio_year--offers-sent'),
        offers_accepted: $('#offer-acceptance-ratio_year--offers-accepted'),
        date: $('#offer-acceptance-ratio_year'),
        form: $('#year-offer-acceptance-ratio_form'),
        remote_url: '/charts/overview/year-offer-acceptance-ratio?'
    }

    // when graph settings are changes
    $('#offer-acceptance-ratios_submit').click(function (event) {
        event.preventDefault();
        let data = $('#offer-acceptance-ratios_form').serialize();
        chart.updateData(`/charts/overview/offer-acceptance-ratios?${data}`)
    });

    function handleSubmitButtonClicked(event, gauge){
        event.preventDefault();
        let data = gauge['form'].serialize();
        $.ajax({
            method: 'GET',
            url: `${gauge['remote_url']}${data}`
        }).then((response) => updateGauge(response, gauge));
    }

    function updateGauge(response, gauge){
        let percent_turn = response['ratio'] == 1 ? 0.5 : 0.5 * response['ratio'];
        gauge['gauge_outer_over'].css('transform', `rotate(${percent_turn}turn`);
        gauge['gauge_data'].text(response['ratio']);
        gauge['offers_sent'].text(response['offers']);
        gauge['offers_accepted'].text(response['accepted_offers']);
        gauge['date'].text(response['date']);
    }

    // when gauge settings are changes
    $('#month-year-offer-acceptance-ratio_submit').click((event) => handleSubmitButtonClicked(event, gauge_for_month_year));
    $('#year-offer-acceptance-ratio_submit').click((event) => handleSubmitButtonClicked(event, gauge_for_year));
})
