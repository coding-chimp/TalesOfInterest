jQuery ->
  $('form').on 'click', '#add_audio_file_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $('#add_audio_file').before($(this).data('fields').replace(regexp, time))
    event.preventDefault()
    $(document).foundation();

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
    $(document).foundation();

$ ->
  $("#episode_published_at").fdatetimepicker
    format: "dd.mm.yyyy hh:ii"
    weekStart: 1
