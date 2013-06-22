jQuery ->
  $('#episode_analytics_table').dataTable
    sDom: "lfrtpi"
    sPaginationType: "bootstrap"
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#episode_analytics_table').data('source')
    bAutoWidth: false
    aaSorting: [[3, 'desc']]
