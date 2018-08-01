$(document).ready(function () {
    // when offer acceptance ratios graph settings are changed 
    $('#offer-acceptance-ratios_submit').click(function (event) {
        event.preventDefault();
        var data = $('#offer-acceptance-ratios_form').serialize();
        window.TADCharts.OAR.months_years_graph.updateData(`/charts/overview/offer-acceptance-ratios?${data}`);
    });

    function handleSubmitButtonClicked(event, gauge){
        event.preventDefault();
        var data = gauge['form'].serialize();
        $.ajax({
            method: 'GET',
            url: `${gauge['remote_url']}${data}`
        }).then((response) => window.ChartsUtil.OAR.updateGauge(response, gauge));
    }

    // when gauge settings are changes
    $('#month-year-offer-acceptance-ratio_submit').click(function(event){
        handleSubmitButtonClicked(event, window.TADCharts.OAR.month_year_gauge);
    });

    $('#year-offer-acceptance-ratio_submit').click(function(event){
        handleSubmitButtonClicked(event, window.TADCharts.OAR.year_gauge);
    });
});
