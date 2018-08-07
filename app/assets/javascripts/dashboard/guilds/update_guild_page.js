$(document).ready(function () {
    if ($('#dashboard_individual-guild-page').length > 0){
        var hires_years_bubbles = $("#chart-status_guild-hires-years .chart-status_bubble");
        var job_stats_bubbles = $("#chart-status_guild-job-stats .chart-status_bubble");
        var update_notification_bar = $('#update-notification');
        $('#notification_message').text("Update complete!");
        update_notification_bar.css("background-color", "#FF6C36");
        // check data-updating of root component
        // if updating, activate bubbles and disable update button
        var channel = pusher.subscribe('private-tad-channel');
        channel.bind("department-update-complete", function (data) {
            // get current guild
            var current_guild = $.param({guild: $('#dashboard_individual-guild-page').data('guild')})
            // var params = $.param({ guild: $('#dashboard_individual-guild-page').data('guild'), years: [2})
            var displaying_notification = false

            $.ajax({
                method: 'GET', 
                url: `/charts/guilds/hires-by-year-for-guild?${current_guild}`
            }).then(function(response){
                window.TADCharts.guilds.year_by_year_graph.updateData(response)
                hires_years_bubbles.removeClass("chart-status_bubble--active")
                // show notification (update complete) if not already present
                // show notification bar for x number of seconds
                if(!displaying_notification){
                    displaying_notification = true
                    update_notification_bar.removeClass('notification_container--hidden');
                    setTimeout(function () {
                        update_notification_bar.addClass("notification_container--hidden");
                        // enable update button
                        // update last updated date
                    }, 3000);
                }
            })

            $.ajax({
                method: 'GET', 
                url: `/charts/guilds/jobs-stats-for-guild?${current_guild}`
            }).then(function(response){
                $('#guild_live-jobs').text(response.live_jobs);
                $('#guild_live-openings').text(response.live_openings);
                job_stats_bubbles.removeClass("chart-status_bubble--active");
                // show notification (update complete) if not already present
                if (!displaying_notification) {
                    displaying_notification = true
                    update_notification_bar.removeClass('notification_container--hidden');
                    setTimeout(function () {
                        update_notification_bar.addClass("notification_container--hidden");
                    }, 3000);
                }
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
    }
});
