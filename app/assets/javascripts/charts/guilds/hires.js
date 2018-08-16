$(document).ready(function () {
    // ---- IF ON GUILDS TAB ----------
    if($('#dashboard_guilds-tab').length > 0){
        $('#hires-by-guild_submit').click(function(event){
            event.preventDefault() 
            var data = $('#hires-by-guild_form').serialize();
            var hires_by_guild_graph = Chartkick.charts["hires-by-guild-graph"];
            hires_by_guild_graph.updateData(`/charts/guilds/hires-by-guild-for-year?${data}`);
            var hires_by_guild_date = $('#hires-by-guild_year');
            var form_date = $('#hires-by-guild_form').serializeArray()[0]['value'];
            hires_by_guild_date.text(form_date);
            hires_by_guild_date.data('date', form_date);
        })
    }
});
