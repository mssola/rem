#
# Let's handle the Address Picker jQuery plugin.
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


#= require jquery.ui.addresspicker


jQuery ->
  holding = $("#search_map").find("div.holding")
  input = holding.find("input:eq(0)")
  holder = holding.find("span.holder")

  holder.click ->
    input.focus()

  input.bind
    focusout: ->
      holder.show() if $(this).val() == ""

    keydown: ->
      holder.hide() if holder.is(":visible")
    

jQuery ->
  addresspicker = $( "#addresspicker" ).addresspicker()
  addresspickerMap = $( "#addresspicker_map" ).addresspicker({
    elements: {
      map:      "#map",
      addr:      "#addr",
      lat:      "#lat",
      lng:      "#lng",
      locality: '#locality',
      country:  '#country'
    }
  })
  gmarker = addresspickerMap.addresspicker( "marker")
  gmarker.setVisible(true)
  addresspickerMap.addresspicker( "updatePosition")

jQuery ->
  $("#addresspicker_map").select ->
    alert 'a'

