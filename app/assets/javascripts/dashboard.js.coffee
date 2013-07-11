jQuery ->
  $("#subscribers_modal").bind "opened", ->
    Morris.Donut
      element: 'subscribers_chart'
      data: $('#subscribers_chart').data('subscribers')

  if $('#traffic_chart').length
    Morris.Area
      element: 'traffic_chart'
      data: $('#traffic_chart').data('traffic')
      xkey: 'date'
      ykeys: ['views', 'people']
      labels: ['Views', 'People']
      lineColors: ['#0b62a4', '#da4f49']
      behaveLikeLine: true
      hideHover: 'auto'
