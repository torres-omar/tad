$(document).ready(function () {
    // select button
    $('#guilds_update-button').click(handleUpdateButtonClick);

    function handleUpdateButtonClick(event){
        event.preventDefault();
        // activate loading bubbles
        var hires_years_bubbles = $("#chart-status_guild-hires-years .chart-status_bubble");
        var job_stats_bubbles = $("#chart-status_guild-job-stats .chart-status_bubble");
        hires_years_bubbles.addClass("chart-status_bubble--active");
        job_stats_bubbles.addClass("chart-status_bubble--active");
        // check to see if button should trigger an update
        var last_updated_date = new Date($('#guilds_last-updated-date').text());
        var last_updated_date_UTC = Date.UTC(last_updated_date.getUTCFullYear(), last_updated_date.getUTCMonth(), last_updated_date.getUTCDay(), last_updated_date.getUTCHours(), last_updated_date.getUTCMinutes());
        var wait = (30 * 60000);
        var wait_window = last_updated_date_UTC + wait;
        if(Date.now() >= wait_window){
            $.ajax({
                method: 'GET', 
                url: '/dashboard/update-guild-data'
            }).then(function(response){console.log(response)}, function(response){console.log(response)})
        }else{
            // tell user that he/she must wait at least 30 minutes for a new update
            console.log('too early to update')
        }

    }

    // function getGuildURL(){
    //     switch($('#dashboard_individual-guild-page').data('guild')){
    //         case 
    //     }
    // }
    // add listener for click event
    // event handler: 
        // loading bubbles
        // ajax call to method that fetches new data
        // method first checks to see if time.now() >= last_updated + 30 min
        // once updating of data is complete in the back
        // send new request for each individual component (hires/year, stats, jobs)
    
});
