#
# Handling some jQuery effects
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


jQuery ->
  # Showing Facebook-like tips with jquery.tipsy
  $('.tip').tipsy { gravity: 'n' }
  $('.stip').tipsy { gravity: 's' }

  # Let's apply some cool effects to Rails flash messages
  $('.flashy').hide()
  $('.flashy').delay(500).slideDown 'normal', ->
    $(this).show()
    $(this).delay(5000).slideUp('slow')

  # Handle JQuery UI tabs
  $("#search_tabs").tabs()

  # Setup the best_in_place feature
  $(".best_in_place").best_in_place()

  # Here it goes the effect for the "span trick" applied to
  # some input widgets.
  $(".span_trick").each ->
    holder = $(this).find("span")
    input = $(this).find(".r_raw_field")
    input = $(this).find("#addresspicker_map") if input.length == 0

    holder.hide() if input.val() != ""

    holder.click ->
      input.focus()

    # Bind the focusout and the keydown events so the span element
    # is hidden when the user is writing something and this same
    # element gets visible when there's nothing on the input element.
    input.bind
      focusout: ->
        holder.show() if $(this).val() == ""

      keydown: ->
        holder.hide() if holder.is(":visible")
