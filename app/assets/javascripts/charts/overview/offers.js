$(document).ready(function () {
    let chart = Chartkick.charts["offer-acceptance-ratios-graph"]
    chart.getChartObject()

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

    function updateYearMonthRatioGauge(data){
        // $('gauge-outer-over_year-month').
    }
})
