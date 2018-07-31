$(document).ready(function () {
    $('#years-hires_submit').click(function(event){
        event.preventDefault();
        var data = $('#years-hires_form').serialize();
        window.TADCharts.Hires.year_by_year_graph.updateData(`/charts/overview/new-hires-years?${data}`);
    });

    var line_options = {
        download: true,
        height: "20rem",
        ytitle: "Hires",
        xtitle: "Month",
        curve: false,
        id: "years-months-hires-graph"
    };
    var column_options = Object.assign({}, line_options)
    column_options['stacked'] = true
    var current_graph_type = $("input[type=radio][name=years-months_graph-type]:checked").val();
    $('#years-months-hires_submit').click(function(event){
        event.preventDefault();
        var data = $('#years-months-hires_form').serialize();
        var selected_graph_type = $("input[type=radio][name=years-months_graph-type]:checked").val();
        var url = `/charts/overview/new-hires-years-months?${data}`;

        if(selected_graph_type != current_graph_type){
            if(selected_graph_type == 'line'){
                window.TADCharts.Hires.years_months_graph = new Chartkick.LineChart('years-months-hires_container', url, line_options);
            }else{
                window.TADCharts.Hires.years_months_graph = new Chartkick.ColumnChart('years-months-hires_container', url, column_options);
            }
            window.TADCharts.Hires.years_months_graph.redraw()
            current_graph_type = selected_graph_type
        }else{
            window.TADCharts.Hires.years_months_graph.updateData(url);
        }
    });

    $('#hires-stats_submit').click(function(event){
        event.preventDefault();
        var data = $('#hires-stats_form').serialize();
        $.ajax({
            method: 'GET',
            url: `/charts/overview/hires-statistics?${data}`
        }).then(function(response){ window.ChartsUtil.Hires.updateStatistics(response) });
    });
})
