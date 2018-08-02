$(document).ready(function () {
    window.TADCharts = {};
    window.TADCharts.OAR = {};
    window.TADCharts.Hires = {};
    if ($('#dashboard_guilds-tab').length > 0){
        TADCharts.Hires.hires_by_guild_graph = Chartkick.charts["hires-by-guild-graph"];
    } else if ($('#dashboard_overview-tab').length > 0){
        TADCharts.Hires.year_by_year_graph = Chartkick.charts["years-hires-graph"];
        TADCharts.Hires.years_months_graph = Chartkick.charts["years-months-hires-graph"];
        TADCharts.Hires.hires_stats = {
            date: $('#hires-stats_date'),
            form: $('#hires-stats_form'),
            average: $('#hires-stats_average'),
            median: $('#hires-stats_median'),
            remote_url: '/charts/overview/hires-statistics?',
            bubbles: $('#chart-status_hires-stats'),
            button: $('#hires-stats_submit')
        }
        TADCharts.Hires.recent_hires = {
            rows_container: $('#recent-hires_rows'),
            bubbles: $("#chart-status_recent-hires .chart-status_bubble"),
            remote_url: '/charts/overview/most-recent-hire'
        }
        TADCharts.OAR.months_years_graph = Chartkick.charts["offer-acceptance-ratios-graph"];
        TADCharts.OAR.month_year_gauge = {
            gauge_outer_over: $('#gauge-outer-over_year-month'),
            gauge_data: $('#gauge-data_year-month'),
            offers_sent: $('#offer-acceptance-ratio_year-month--offers-sent'),
            offers_accepted: $('#offer-acceptance-ratio_year-month--offers-accepted'),
            date: $('#offer-acceptance-ratio_date'),
            form: $('#month-year-offer-acceptance-ratio_form'),
            remote_url: '/charts/overview/month-year-offer-acceptance-ratio?',
            bubbles: $('#chart-status_offer-ratio-month-year .chart-status_bubble'),
            button: $("#month-year-offer-acceptance-ratio_submit")
        };
        TADCharts.OAR.year_gauge = {
            gauge_outer_over: $('#gauge-outer-over_year'),
            gauge_data: $('#gauge-data_year'),
            offers_sent: $('#offer-acceptance-ratio_year--offers-sent'),
            offers_accepted: $('#offer-acceptance-ratio_year--offers-accepted'),
            date: $('#offer-acceptance-ratio_year'),
            form: $('#year-offer-acceptance-ratio_form'),
            remote_url: '/charts/overview/year-offer-acceptance-ratio?',
            bubbles: $('#chart-status_offer-ratio-year .chart-status_bubble'),
            button: $("#year-offer-acceptance-ratio_submit")
        };
    }
});
