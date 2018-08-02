$(document).ready(function () {
    $('#hires-by-guild_submit').click(function(event){
        event.preventDefault() 
        var data = $('#hires-by-guild_form').serialize();
        window.TADCharts.Hires.hires_by_guild.updateData(`/charts/guilds/hires-by-guild-for-year?${data}`);
        $('#hires-by-guild_year').text($('#hires-by-guild_form').serializeArray()[0]['value']);
    })
});
