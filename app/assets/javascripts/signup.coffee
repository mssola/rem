#
# Client-side functions related to form validations.
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


##
# Let's do some work on the Sign Up page in order to have all the
# design as it should be.
$(document).ready ->
  holding = $("#new_user").find("div.holding")

  holding.each ->
    input = $(this).find("input:eq(0)")
    holder = $(this).find("span.holder")

    # If the span element is clicked, focus the input.
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

