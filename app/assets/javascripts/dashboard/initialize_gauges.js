$(document).ready(function() {
    // initial gauge ratios display 
    if($('#dashboard_overview-tab').length > 0){
        var gauge_outer_over_year_month = $('#gauge-outer-over_year-month');
        var gauge_outer_over_year = $('#gauge-outer-over_year');
        var initial_ratio_year_month = gauge_outer_over_year_month.data('ratio');
        var initial_ratio_year = gauge_outer_over_year.data('ratio')
        gauge_outer_over_year_month.css('transform', `rotate(${.5 * initial_ratio_year_month}turn)`);
        gauge_outer_over_year.css('transform', `rotate(${.5 * initial_ratio_year}turn)`); 
    } else if ($('#dashboard_individual-guild-page').length > 0){
        var gauge_jobs_percent = $('#gauge-outer-over_jobs-percent');
        var initial_jobs_percent = gauge_jobs_percent.data('ratio');
        gauge_jobs_percent.css('transform', `rotate(${.5 * initial_jobs_percent}turn)`);
    }
});
