$(document).ready(function () {
    window.TADCharts = {};
    window.TADCharts.OAR = {};
    window.TADCharts.Hires = {};
    TADCharts.Hires.year_by_year_graph = Chartkick.charts["years-hires-graph"];
    TADCharts.Hires.years_months_graph = Chartkick.charts["years-months-hires-graph"];
    TADCharts.OAR.months_years_graph = Chartkick.charts["offer-acceptance-ratios-graph"];
    TADCharts.OAR.month_year_gauge = {
        gauge_outer_over: $('#gauge-outer-over_year-month'),
        gauge_data: $('#gauge-data_year-month'),
        offers_sent: $('#offer-acceptance-ratio_year-month--offers-sent'),
        offers_accepted: $('#offer-acceptance-ratio_year-month--offers-accepted'),
        date: $('#offer-acceptance-ratio_date'),
        form: $('#month-year-offer-acceptance-ratio_form'),
        remote_url: '/charts/overview/month-year-offer-acceptance-ratio?',
        bubbles: $('#chart-status_offer-ratio-month-year .chart-status_bubble')
    };
    TADCharts.OAR.year_gauge = {
        gauge_outer_over: $('#gauge-outer-over_year'),
        gauge_data: $('#gauge-data_year'),
        offers_sent: $('#offer-acceptance-ratio_year--offers-sent'),
        offers_accepted: $('#offer-acceptance-ratio_year--offers-accepted'),
        date: $('#offer-acceptance-ratio_year'),
        form: $('#year-offer-acceptance-ratio_form'),
        remote_url: '/charts/overview/year-offer-acceptance-ratio?',
        bubbles: $('#chart-status_offer-ratio-year .chart-status_bubble')
    };
});
