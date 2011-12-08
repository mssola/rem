

# The code below handles the action buttons menu
$(document).ready ->
  # If clicked, toogle the menu
  $('.acting').click (e) ->
    e.preventDefault()
    $('fieldset#action_menu').toggle()
    $('.acting').toggleClass 'menu-open'

  # Return false on mouseup event
  $('fieldset#action_menu').mouseup -> false

  #Hide the menu if we are clicking to another part of the site
  $(document).mouseup (e) ->
    if $(e.target).parent('a.acting').length == 0
      $('.acting').removeClass 'menu-open'
      $('fieldset#action_menu').hide()
