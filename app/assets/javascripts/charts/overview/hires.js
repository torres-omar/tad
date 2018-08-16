$(document).ready(function () {
    // ----- IF ON OVERVIEW TAB ----------
    if($('#dashboard_overview-tab').length > 0){
        // ------ UTILITY FUNCTIONS --------
        function updateStatistics(response) {
            $('#hires-stats_date').text(response['date']);
            $('#hires-stats_date').data('date', response['date']);
            $('#hires-stats_average').text(response['average']);
            $('#hires-stats_median').text(response['median']);
        }
    
        $('#years-hires_submit').click(function(event){
            event.preventDefault();
            var data = $('#years-hires_form').serialize();
            var year_by_year_graph = Chartkick.charts["years-hires-graph"];
            year_by_year_graph.updateData(`/charts/overview/new-hires-years?${data}`);
        });
    
        var line_options = {
            download: false,
            height: "20rem",
            ytitle: "Hires",
            xtitle: "Month",
            curve: false,
            id: "years-months-hires-graph"
        };
        
        var column_options = Object.assign({}, line_options)
        column_options['stacked'] = true
        var current_graph_type = $("input[type=radio][name=years-months_graph-type]:checked").val();
        var years_months_graph = Chartkick.charts["years-months-hires-graph"];
    
        $('#years-months-hires_submit').click(function(event){
            event.preventDefault();
            var data = $('#years-months-hires_form').serialize();
            var selected_graph_type = $("input[type=radio][name=years-months_graph-type]:checked").val();
            var url = `/charts/overview/new-hires-years-months?${data}`;
            if(selected_graph_type != current_graph_type){
                if(selected_graph_type == 'line'){
                    years_months_graph = new Chartkick.LineChart('years-months-hires_container', url, line_options);
                }else{
                    years_months_graph = new Chartkick.ColumnChart('years-months-hires_container', url, column_options);
                }
                years_months_graph.redraw()
                current_graph_type = selected_graph_type
            }else{
                years_months_graph.updateData(url);
            }
        });
    
        $('#hires-stats_submit').click(function(event){
            event.preventDefault();
            var data = $('#hires-stats_form').serialize();
            $.ajax({
                method: 'GET',
                url: `/charts/overview/hires-statistics?${data}`
            }).then(function(response){ updateStatistics(response) });
        });
    }
})
