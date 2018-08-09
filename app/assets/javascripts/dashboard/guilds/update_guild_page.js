$(document).ready(function () {
    if ($('#dashboard_individual-guild-page').length > 0){
        // select bubbles, update button, and notification bar
        var days_to_hire_bubbles = $('#chart-status_days-to-hire .chart-status_bubble');
        var job_stats_bubbles = $("#chart-status_guild-job-stats .chart-status_bubble");
        var percent_of_jobs_bubbles = $('#chart-status_percent-of-jobs .chart-status-bubble')
        var hires_years_bubbles = $("#chart-status_guild-hires-years .chart-status_bubble");
        var update_button = $('#guilds_update-button');
        var update_notification_bar = $('#update-notification');

        // change notification bar color
        update_notification_bar.css("background-color", "#FF6C36");

        // check data-updating attribute of root component
        // if updating, activate bubbles and disable update button
        if($('#dashboard_individual-guild-page').data('updating')){
            days_to_hire_bubbles.addClass("chart-status_bubble--active");
            job_stats_bubbles.addClass("chart-status_bubble--active");
            percent_of_jobs_bubbles.addClass("chart-status_bubble--active");
            hires_years_bubbles.addClass("chart-status_bubble--active");
            update_button.attr('disabled', true);
        }

        // subscribe to pusher event: when update is complete
        var channel = pusher.subscribe('private-tad-channel');
        channel.bind("department-update-complete", function (data) {
            // show notification bar & refresh page
            $('#notification_message').text("Update complete!");
            update_notification_bar.removeClass('notification_container--hidden');
            setTimeout(function(){
                location.reload();
            }, 3000);
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
                days_to_hire_bubbles.addClass("chart-status_bubble--active");
                job_stats_bubbles.addClass("chart-status_bubble--active");
                percent_of_jobs_bubbles.addClass("chart-status_bubble--active");
                hires_years_bubbles.addClass("chart-status_bubble--active");
                update_button.attr('disabled', true);
                // update database by making calls to greenhouse api
                $.ajax({
                    method: 'GET',
                    url: '/dashboard/update-guild-data'
                });
            } else {
                // if user tries to update before 30 minutes are up
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

