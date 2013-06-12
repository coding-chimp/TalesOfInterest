jQuery ->
  $('form').on 'click', '#add_audio_file_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $('#add_audio_file').before($(this).data('fields').replace(regexp, time))
    event.preventDefault()

  $('#show_notes').sortable
    axis: 'y'
    handle: '.handle'
    update: ->
      $.post($(this).data('update-url'), $(this).sortable('serialize'))

  $('form').on 'click', '#add_show_note_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $('#add_show_note').before($(this).data('fields').replace(regexp, time))
    event.preventDefault()

  $('form').on 'click', '#add_introduced_title_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $('#add_introduced_title').before($(this).data('fields').replace(regexp, time))
    event.preventDefault()

$ ->
  $("#datetimepicker1").datetimepicker
    format: "dd.MM.yyyy hh:mm"
