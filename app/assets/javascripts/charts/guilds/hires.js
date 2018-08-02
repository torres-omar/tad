$(document).ready(function () {
    $('#hires-by-guild_submit').click(function(event){
        event.preventDefault() 
        var data = $('#hires-by-guild_form').serialize();
        window.TADCharts.Hires.hires_by_guild_graph.updateData(`/charts/guilds/hires-by-guild-for-year?${data}`);
        var hires_by_guild_date = $('#hires-by-guild_year');
        var form_date = $('#hires-by-guild_form').serializeArray()[0]['value'];
        hires_by_guild_date.text(form_date);
        hires_by_guild_date.data('date', form_date);
    })
});
