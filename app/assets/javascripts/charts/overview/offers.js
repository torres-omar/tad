$(document).ready(function () {
    let chart = Chartkick.charts["offer-acceptance-ratios-graph"]
    // year_month
    let year_month_gauge_outer_over = $('#gauge-outer-over_year-month');
    let year_month_gauge_data = $('#gauge-data_year-month');
    let year_month_offers_sent = $('#offer-acceptance-ratio_year-month--offers-sent');
    let year_month_offers_accepted = $('#offer-acceptance-ratio_year-month--offers-accepted');
    let year_month_date = $('#offer-acceptance-ratio_date');
    // year
    let year_gauge_outer_over = $('#gauge-outer-over_year');
    let year_gauge_data = $('#gauge-data_year');
    let year_offers_sent = $('#offer-acceptance-ratio_year--offers-sent');
    let year_offers_accepted = $('#offer-acceptance-ratio_year--offers-accepted');
    let year_date = $('#offer-acceptance-ratio_year');

    $('#offer-acceptance-ratios_submit').click(function (event) {
        event.preventDefault();
        let data = $('#offer-acceptance-ratios_form').serialize();
        chart.updateData(`/charts/overview/offer-acceptance-ratios?${data}`)
    });

    $('#month-year-offer-acceptance-ratio_submit').click(function(event){
        event.preventDefault();
        let data = $('#month-year-offer-acceptance-ratio_form').serialize();
        $.ajax({
            method: 'GET',
            url: `/charts/overview/month-year-offer-acceptance-ratio?${data}`
        }).then(updateYearMonthRatioGauge);
    })

    $('#year-offer-acceptance-ratio_submit').click(function(event){
        event.preventDefault();
        let data = $('#year-offer-acceptance-ratio_form').serialize();
        $.ajax({
            method: 'GET',
            url: `/charts/overview/year-offer-acceptance-ratio?${data}`
        }).then(updateYearRatioGauge);
    })

    function updateYearMonthRatioGauge(data){
        let percent_turn  = data['ratio'] == 1 ? 0.5 : 0.5 * data['ratio'];
        year_month_gauge_outer_over.css('transform', `rotate(${percent_turn}turn`);
        year_month_gauge_data.text(data['ratio']);
        year_month_offers_sent.text(data['offers']);
        year_month_offers_accepted.text(data['accepted_offers']);
        year_month_date.text(data['date']);
    }

    function updateYearRatioGauge(data){
        let percent_turn = data['ratio'] == 1 ? 0.5 : 0.5 * data['ratio'];
        year_gauge_outer_over.css('transform', `rotate(${percent_turn}turn`);
        year_gauge_data.text(data['ratio']);
        year_offers_sent.text(data['offers']);
        year_offers_accepted.text(data['accepted_offers'])
        year_date.text(data['date']);
    }
})
