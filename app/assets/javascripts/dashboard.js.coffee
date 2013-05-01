# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
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
