jQuery ->
  mobilenav = $('#mobile-nav')

  $("html").click ->
  mobilenav.find(".on").each ->
    $(this).removeClass("on").next().hide()


  mobilenav.on("click", ".menu .button", ->
    unless $(this).hasClass("on")
      width = $(this).width() + 42
      $(this).addClass("on").next().show().css width: width
    else
      $(this).removeClass("on").next().hide()
  ).on("click", ".search .button", ->
    unless $(this).hasClass("on")
      width = mobilenav.width() - 51
      mobilenav.children(".menu").children().eq(0).removeClass("on").next().hide()
      $(this).addClass("on").next().show().css(width: width).children().children().eq(0).focus()
    else
      $(this).removeClass("on").next().hide().children().children().eq(0).val ""
  ).click (e) ->
    e.stopPropagation()

  $(document).keydown (e) ->
    if e.keyCode is 27
      $(location).attr('href', '/login')
      false
