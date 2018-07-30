$(document).ready(function () {
    debugger
    window.Charts = {};
    window.Charts.OAR = {};
    window.Charts.Hires = {};
    Charts.Hires.year_by_year_graph = Chartkick.charts["years-hires-graph"];
    Charts.Hires.years_months_graph = Chartkick.charts["years-months-hires-graph"];
    Charts.OAR.months_years_graph = Chartkick.charts["offer-acceptance-ratios-graph"];
    Charts.OAR.month_year_gauge = {
        gauge_outer_over: $('#gauge-outer-over_year-month'),
        gauge_data: $('#gauge-data_year-month'),
        offers_sent: $('#offer-acceptance-ratio_year-month--offers-sent'),
        offers_accepted: $('#offer-acceptance-ratio_year-month--offers-accepted'),
        date: $('#offer-acceptance-ratio_date'),
        form: $('#month-year-offer-acceptance-ratio_form'),
        remote_url: '/charts/overview/month-year-offer-acceptance-ratio?'
    };
    Charts.OAR.year_gauge = {
        gauge_outer_over: $('#gauge-outer-over_year'),
        gauge_data: $('#gauge-data_year'),
        offers_sent: $('#offer-acceptance-ratio_year--offers-sent'),
        offers_accepted: $('#offer-acceptance-ratio_year--offers-accepted'),
        date: $('#offer-acceptance-ratio_year'),
        form: $('#year-offer-acceptance-ratio_form'),
        remote_url: '/charts/overview/year-offer-acceptance-ratio?'
    };
});
