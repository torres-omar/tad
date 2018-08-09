$(document).ready(function(){
    var initial_jobs_percent = $('#gauge-outer-over_jobs-percent').data('ratio');
    $('#gauge-outer-over_jobs-percent').css('transform', `rotate(${.5 * initial_jobs_percent}turn)`);
}); 
