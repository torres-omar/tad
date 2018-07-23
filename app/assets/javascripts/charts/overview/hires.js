$(document).ready(function () {
    let years_chart = Chartkick.charts["years-hires-graph"];
    let years_months_chart = Chartkick.charts["years-months-hires-graph"];
    let current_graph_type = $("input[type=radio][name=years-months_graph-type]:checked").val();
    let line_options = {
        download: true,
        height: "20rem",
        ytitle: "Hires",
        xtitle: "Month",
        curve: false,
        id: "years-months-hires-graph"
    };
    let column_options = Object.assign({}, line_options)
    column_options['stacked'] = true

    $('#years-hires_submit').click((event) => {
        event.preventDefault();
        let data = $('#years-hires_form').serialize();
        years_chart.updateData(`/charts/overview/new-hires-years?${data}`)
    });

    $('#years-months-hires_submit').click((event) => {
        event.preventDefault();
        let data = $('#years-months-hires_form').serialize();
        let selected_graph_type = $("input[type=radio][name=years-months_graph-type]:checked").val();
        let url = `/charts/overview/new-hires-years-months?${data}`;

        if(selected_graph_type != current_graph_type){
            if(selected_graph_type == 'line'){
                years_months_chart = new Chartkick.LineChart('years-months-hires_container', url, line_options);
            }else{
                years_months_chart = new Chartkick.ColumnChart('years-months-hires_container', url, column_options);
            }
            years_months_chart.redraw()
            current_graph_type = selected_graph_type
        }else{
            years_months_chart.updateData(url);
        }
    })

})
