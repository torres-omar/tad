$(document).ready(function(){
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
    if ($('#dashboard_individual-guild-page').length > 0){
        // fetch jobs
        var params = $.param({ guild: $('#dashboard_individual-guild-page').data('guild') });
        $.ajax({
            method: 'GET', 
            url: `/charts/guilds/open-jobs-for-guild?${params}`
        }).then(function(response){
            $('#guilds_jobs-search-bar').autocomplete({
                source: response,
                classes: {
                    "ui-autocomplete": "guilds_jobs-search-menu"
                }
            });
        })
    }
}); 
