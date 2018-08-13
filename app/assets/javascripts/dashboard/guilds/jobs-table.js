$(document).ready(function(){
    $('#test-table').DataTable({"order": []})
    // on load, get all the live open jobs for the current department
    // pass them in as the source option for the autocomplete component
    // add an id property to the option items 
    // when an item is selected go to that job's page 
    // $('#guilds_jobs-search-bar').autocomplete({
    //     source: [{ label: "Choice1", id: 3 }, { label: "Choice2", id: 1}],
    //     select: function (event, ui) { 
    //         window.location = 'https://www.google.com/'
    //     }
    // })
    // if ($('#dashboard_individual-guild-page').length > 0){
    //     $('#guild_jobs-search-bar').autocomplete({
    //         classes: {
    //             "ui-autocomplete": "guild_jobs-search-menu"
    //         },
    //         appendTo: "#append-to-this",
    //         select: function (event, ui) {
    //             console.log(ui.item.id)
    //         }
    //     });

    //     var params = $.param({ guild: $('#dashboard_individual-guild-page').data('guild') });
    //     $.ajax({
    //         method: 'GET', 
    //         url: `/charts/guilds/open-jobs-for-guild?${params}`
    //     }).then(function(response){
    //         $('#guild_jobs-search-bar').autocomplete('option', 'source', response)
    //     });

    //     var current_option = $('#guilds_jobs-source-control input[name="guild-jobs"]:checked').val();
    //     $('#guilds_jobs-source-control input[name="guild-jobs"]').click(function(){
    //         var selected_option = $('#guilds_jobs-source-control input[name="guild-jobs"]:checked').val()
    //         if (selected_option != current_option){
    //             current_option = selected_option;
    //             $('#guild_jobs-search-bar').attr('disabled', true);
    //             $('#chart-status_guild-job-search .chart-status_bubble').addClass("chart-status_bubble--active");
    //             if(selected_option == 'open'){
    //                 $.ajax({
    //                     method: 'GET',
    //                     url: `/charts/guilds/open-jobs-for-guild?${params}`
    //                 }).then(function(response){
    //                     $('#guild_jobs-search-bar').autocomplete('option', 'source', response)
    //                     setTimeout(function(){
    //                         $('#chart-status_guild-job-search .chart-status_bubble').removeClass("chart-status_bubble--active");
    //                         $('#guild_jobs-search-bar').removeAttr('disabled');
    //                     }, 2000);
    //                 });
    //             }else if(selected_option == 'closed'){
    //                 $.ajax({
    //                     method: 'GET',
    //                     url: `/charts/guilds/closed-jobs-for-guild?${params}`
    //                 }).then(function (response) {
    //                     $('#guild_jobs-search-bar').autocomplete('option', 'source', response)
    //                     setTimeout(function () {
    //                         $('#chart-status_guild-job-search .chart-status_bubble').removeClass("chart-status_bubble--active");
    //                         $('#guild_jobs-search-bar').removeAttr('disabled');
    //                     }, 2000);
    //                 });
    //             }
    //         }
    //     })
    // }
}); 
