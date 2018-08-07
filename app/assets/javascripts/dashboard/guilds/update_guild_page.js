$(document).ready(function () {
    if ($('#dashboard_individual-guild-page').length > 0){
        var hires_years_bubbles = $("#chart-status_guild-hires-years .chart-status_bubble");
        var job_stats_bubbles = $("#chart-status_guild-job-stats .chart-status_bubble");
        var update_button = $('#guilds_update-button');
        var update_notification_bar = $('#update-notification');

        
        update_notification_bar.css("background-color", "#FF6C36");
        // check data-updating of root component
        // if updating, activate bubbles and disable update button
        if($('#dashboard_individual-guild-page').data('updating')){
            hires_years_bubbles.addClass("chart-status_bubble--active");
            job_stats_bubbles.addClass("chart-status_bubble--active");
            update_button.attr('disabled', true);
        }

        var channel = pusher.subscribe('private-tad-channel');
        channel.bind("department-update-complete", function (data) {
            $('#notification_message').text("Update complete!");
            var current_guild = $.param({guild: $('#dashboard_individual-guild-page').data('guild')})
            var displaying_notification = false

            $.ajax({
                method: 'GET', 
                url: `/charts/guilds/hires-by-year-for-guild?${current_guild}`
            }).then(function(response){
                window.TADCharts.guilds.year_by_year_graph.updateData(response);
                hires_years_bubbles.removeClass("chart-status_bubble--active");
                // show notification (update complete) if not already present
                // show notification bar for x number of seconds
                if(!displaying_notification){
                    displaying_notification = true
                    update_notification_bar.removeClass('notification_container--hidden');
                    update_button.removeAttr('disabled')
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
                    update_button.removeAttr('disabled')
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
            // check to see if button should trigger an update
            var last_updated_date = new Date($('#guilds_last-updated-date').data('last-updated')).getTime();
            var wait = (30 * 60000);
            var wait_window = last_updated_date + wait;
            if (Date.now() >= wait_window) {
                // activate loading bubbles and disable update button
                hires_years_bubbles.addClass("chart-status_bubble--active");
                job_stats_bubbles.addClass("chart-status_bubble--active");
                update_button.attr('disabled', true);

                // update database by making calls to greenhouse api
                $.ajax({
                    method: 'GET',
                    url: '/dashboard/update-guild-data'
                }).then(null, function(errors){
                    hires_years_bubbles.removeClass("chart-status_bubble--active");
                    job_stats_bubbles.removeClass("chart-status_bubble--active");
                    update_button.removeAttr('disabled')
                    $('#notification_message').text("You can only update once every 30 min.");
                    update_notification_bar.removeClass('notification_container--hidden');
                    setTimeout(function () {
                        update_notification_bar.addClass("notification_container--hidden");
                    }, 3000);
                });
            } else {
                update_button.attr('disabled', true);
                $('#notification_message').text("You can only update once every 30 min.");
                update_notification_bar.removeClass('notification_container--hidden');
                setTimeout(function () {
                    update_notification_bar.addClass("notification_container--hidden");
                    update_button.removeAttr('disabled')
                }, 3000);
            }
        }
    }
});
