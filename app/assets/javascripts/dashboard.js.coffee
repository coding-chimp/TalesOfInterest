jQuery ->
  $("#dashboard_podcast_table").tooltip selector: "a[data-toggle=tooltip]"
  
  Morris.Donut
    element: 'Celluloid_subscribers_chart'
    data: $('#Celluloid_subscribers_chart').data('subscribers')

  Morris.Donut
    element: 'Recordcase_subscribers_chart'
    data: $('#Recordcase_subscribers_chart').data('subscribers')

  Morris.Donut
    element: 'Tales_subscribers_chart'
    data: $('#Tales_subscribers_chart').data('subscribers')

  Morris.Area
    element: 'traffic_chart'
    data: $('#traffic_chart').data('traffic')
    xkey: 'date'
    ykeys: ['views', 'people']
    labels: ['Views', 'People']
    lineColors: ['#0b62a4', '#da4f49']
    behaveLikeLine: true
    hideHover: 'auto'
