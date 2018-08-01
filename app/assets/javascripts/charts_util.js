$(document).ready(function() {
    window.ChartsUtil = {};
    window.ChartsUtil.Shared = {};
    window.ChartsUtil.OAR = {};
    window.ChartsUtil.Hires = {};
    ChartsUtil.OAR.updateGauge = function (response, gauge) {
        var percent_turn = response['ratio'] == 1 ? 0.5 : 0.5 * response['ratio'];
        gauge['gauge_outer_over'].css('transform', `rotate(${percent_turn}turn`);
        gauge['gauge_data'].text(response['ratio']);
        gauge['offers_sent'].text(response['offers']);
        gauge['offers_accepted'].text(response['accepted_offers']);
        gauge['date'].text(response['date']);
        gauge['date'].data('date',response['date']);
        if(response['month'] && response['year']){
            gauge['date'].data("year", response['year']);
            gauge['date'].data("month", response['month']);
        }
    }
    ChartsUtil.Hires.updateStatistics = function(response) {
        $('#hires-stats_date').text(response['date']);
        $('#hires-stats_date').data('date',response['date']);
        $('#hires-stats_average').text(response['average']);
        $('#hires-stats_median').text(response['median']);
    }
    ChartsUtil.Hires.updateRecentHires = function(response){
        if ($($('.recent-hire_info-container').first()).data('candidate-id') != response['candidate_id']){
            $($('.recent-hire_info-container').last()).remove()
            var new_row = $('<div/>', { 'class': 'recent-hire_info-container mb-1', 'data-candidate-id': `${response['candidate_id']}`}).append(
                $('<div/>', {'class': 'container-fluid'}).append(
                    $('<div/>', { 'class': 'row' }).append(
                        $('<div/>', { 'class': "col-md-1 col-lg-1 d-flex align-items-center justify-content-center table-column_sm" }).append(
                            $('<i/>', { 'class': "material-icons recent-hire_icon table-column_sm", 'text': 'perm_identity' })
                        )
                    ).append(
                        $('<div/>', { 'class': "col-6 col-md-4 col-lg-3 d-flex align-items-center" }).append(
                            $('<p/>', { 'class': "recent-hire_info", 'text': `${response['hire_name']}` })
                        )
                    ).append(
                        $('<div/>', { 'class': "col-6 col-md-4 col-lg-3 d-flex align-items-center" }).append(
                            $('<p/>', { 'class': "recent-hire_info", 'text': `${response['job']}` })
                        )
                    ).append(
                        $('<div/>', { 'class': "col-md-3 col-lg-3 d-flex align-items-center table-column_sm"}).append(
                            $('<p/>', { 'class': "recent-hire_info table-column_sm", 'text': `${response['guild']}`})
                        )
                    ).append(
                        $('<div/>', { 'class': "col-lg-2 d-flex align-items-center table-column_lg"}).append(
                            $('<p/>', { 'class': "recent-hire_info table-column_lg", 'text': `${response['hire_date']}`})
                        )
                    )
                )
            )
            $('#recent-hires_rows').prepend(new_row)
        }
    }
    ChartsUtil.Shared.handleWebhookEventUpdateChart = function(args){
        args.bubbles.addClass("chart-status_bubble--active");
        if (args.button) { args.button.attr('disabled', 'true'); }
        $.ajax({
            method: 'GET',
            url: `${args.url}${args.params}`,
        }).then(function (response) {
            setTimeout(function () {
                switch (args.type) {
                    case 'Gauge':
                        window.ChartsUtil.OAR.updateGauge(response, args.chart);
                        break;
                    case 'Graph':
                        args.chart.updateData(response);
                        break;
                    case 'Hires-stats':
                        window.ChartsUtil.Hires.updateStatistics(response);
                        break;
                    case 'Recent-hires':
                        window.ChartsUtil.Hires.updateRecentHires(response);
                        break;
                }
                args.bubbles.removeClass("chart-status_bubble--active");
                if (args.button) { args.button.removeAttr('disabled'); }
            }, 2000);
        });
    }
});
