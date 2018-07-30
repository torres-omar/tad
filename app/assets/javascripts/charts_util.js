$(document).ready(function() {
    window.ChartsUtil = {};
    window.ChartsUtil.OAR = {};
    window.ChartsUtil.Hires = {};
    ChartsUtil.OAR.updateGauge = function (response, gauge) {
        var percent_turn = response['ratio'] == 1 ? 0.5 : 0.5 * response['ratio'];
        gauge['gauge_outer_over'].css('transform', `rotate(${percent_turn}turn`);
        gauge['gauge_data'].text(response['ratio']);
        gauge['offers_sent'].text(response['offers']);
        gauge['offers_accepted'].text(response['accepted_offers']);
        gauge['date'].text(response['date']);
        gauge['date'].data("year", response['year']);
        gauge['date'].data("month", response['month']);
    }
    ChartsUtil.Hires.updateStatistics = function(response) {
        $('#hires-stats_date').text(response['date']);
        $('#hires-stats_average').text(response['average']);
        $('#hires-stats_median').text(response['median']);
    }
});
