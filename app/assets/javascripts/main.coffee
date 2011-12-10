#
# Main CoffeeScript file.
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


#= require sparky
#= require users
#= require signup
#= require account
#= require login
#= require address_picker
#= require routes_filter
#= require places

#= require gmaps4rails/googlemaps


# Handle the special search input on the top.
jQuery ->
  holder = $("#top_search").find("span")
  input = $("#top_search").find("input:eq(0)")

  # If the user comes from the home page, he may set some values already.
  holder.hide() if input.val() != ""
  $("#search_tabs").tabs() # jquery ui tabs

  holder.click ->
    input.focus()

  input.bind
    focusout: ->
      holder.show() if $(this).val() == ""

    keydown: ->
      holder.hide() if holder.is(":visible")

# TODO: ugly
jQuery ->
  holder = $(".holding").find("span")
  input = $(".holding").find(".r_raw_field")

  holder.click ->
    input.focus()

  input.bind
    focusout: ->
      holder.show() if $(this).val() == ""

    keydown: ->
      holder.hide() if holder.is(":visible")


# Setup best_in_place
jQuery ->
  $(".best_in_place").best_in_place()

