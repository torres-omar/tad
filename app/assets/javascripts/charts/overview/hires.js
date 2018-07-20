$(document).ready(function () {
    let chart = Chartkick.charts["years-hires-graph"]
    chart.getChartObject()

    $('#years-hires_submit').click(function (event) {
        event.preventDefault();
        let data = $('#years-hires_form').serialize();
        chart.updateData(`/charts/overview/new-hires-years?${data}`)
    });
})
