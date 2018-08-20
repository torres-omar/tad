$(document).ready(function(){
    $('#days-to-hire-table').DataTable({"order": [ [5, 'desc'] ]});
    $('#days-to-hire-table_length select').addClass('custom-select days-to-hire-table_custom-select');
    $('#days-to-hire-table_filter input').addClass('form-control');
}); 
