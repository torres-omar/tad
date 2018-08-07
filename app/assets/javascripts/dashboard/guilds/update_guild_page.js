$(document).ready(function () {
    if ($('#dashboard_individual-guild-page').length > 0){
        var hires_years_bubbles = $("#chart-status_guild-hires-years .chart-status_bubble");
        var job_stats_bubbles = $("#chart-status_guild-job-stats .chart-status_bubble");
        // check data-updating of root component
        // if updating, activate bubbles and disable update button
        var channel = pusher.subscribe('private-tad-channel');
        channel.bind("department-update-complete", function (data) {
            // make calls to db for updating data for each component on page (hires, live jobs/openings, jobs) 
            // once complete, disable bubbles and activate update button
            
            // get current guild
            let current_guild = $.param({guild: $('#dashboard_individual-guild-page').data('guild')})

            $.ajax({
                method: 'GET', 
                url: `/charts/guilds/hires-by-year-for-guild?${current_guild}`
            }).then(function(response){
                window.TADCharts.guilds.year_by_year_graph.updateDate(response)
                hires_years_bubbles.removeClass("chart-status_bubble--active")
                // show notification (update complete) if not already present
            })

            $.ajax({
                method: 'GET', 
                url: `/charts/guilds/jobs-stats-for-guild?${current_guild}`
            }).then(function(event){
                
            })
        })

        // select button
        $('#guilds_update-button').click(handleUpdateButtonClick);
        function handleUpdateButtonClick(event) {
            event.preventDefault();
            // activate loading bubbles
            hires_years_bubbles.addClass("chart-status_bubble--active");
            job_stats_bubbles.addClass("chart-status_bubble--active");
            // check to see if button should trigger an update
            var last_updated_date = new Date($('#guilds_last-updated-date').text());
            var last_updated_date_UTC = Date.UTC(last_updated_date.getUTCFullYear(), last_updated_date.getUTCMonth(), last_updated_date.getUTCDay(), last_updated_date.getUTCHours(), last_updated_date.getUTCMinutes());
            var wait = (30 * 60000);
            var wait_window = last_updated_date_UTC + wait;
            if (Date.now() >= wait_window) {
                // update database
                $.ajax({
                    method: 'GET',
                    url: '/dashboard/update-guild-data'
                }).then(null, function(errors){console.log(errors)})
            } else {
                // tell user that he/she must wait at least 30 minutes for a new update
                console.log('too early to update')
            }
        }

    // add listener for click event
    // event handler: 
        // loading bubbles
        // ajax call to method that fetches new data
        // method first checks to see if time.now() >= last_updated + 30 min
        // once updating of data is complete in the back
        // send new request for each individual component (hires/year, stats, jobs)

    }
});
