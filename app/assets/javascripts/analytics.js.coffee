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
      $("#episode_analytics_table tbody tr").on "click", ->
        table = $('#episode_analytics_table').dataTable()
        position = table.fnGetPosition(this)
        name = table.fnGetData(position)[4]
        $.getScript "?episode=" + name, ->
          Chart.render()
          $(window).scrollTop $('#graph').offset().top

  if $('#downloads_chart').length
    Chart.render()

@Chart = 
  render: ->
    Morris.Area
      element: 'downloads_chart'
      data: $('#downloads_chart').data('downloads')
      xkey: 'date'
      ykeys: $('#downloads_chart').data('files')
      labels: $('#downloads_chart').data('files')
      lineColors: ['#0b62a4', '#da4f49']