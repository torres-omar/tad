$(document).ready(function () {
    let chart = Chartkick.charts["offer-acceptance-ratios-graph"]
    chart.getChartObject()

    $('#offer-acceptance-ratios_submit').click(function (event) {
        event.preventDefault();
        let data = $('#offer-acceptance-ratios_form').serialize();
        chart.updateData(`/charts/overview/offer-acceptance-ratios?${data}`)
    });
})
