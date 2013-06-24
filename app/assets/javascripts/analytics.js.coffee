jQuery ->
  $('#episode_analytics_table').dataTable
    sDom: "lfrtpi"
    sPaginationType: "bootstrap"
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#episode_analytics_table').data('source')
    bAutoWidth: false
    aaSorting: [[3, 'desc']]
    aoColumns: [ null, null, null, null, { bVisible: false } ]
    fnDrawCallback: ->
      $("#episode_analytics_table tbody tr").click ->
        table = $('#episode_analytics_table').dataTable()
        position = table.fnGetPosition(this)
        name = table.fnGetData(position)[4]
        document.location.href = "?episode=" + name

  $('#episode_analytics_table tbody tr').click

  if $('#downloads_chart').length
    Morris.Area
      element: 'downloads_chart'
      data: $('#downloads_chart').data('downloads')
      xkey: 'date'
      ykeys: $('#downloads_chart').data('files')
      labels: $('#downloads_chart').data('files')
      lineColors: ['#0b62a4', '#da4f49']
