#
# Copyright (C) 2011 Miquel Sabaté <mikisabate@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#


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
