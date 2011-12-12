#
# Handle all the effects related to the edit place page.
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
  $(".editable").each ->
    $(this).prop 'disabled', 'true'

  $(".hide_link").click (e) ->
    e.preventDefault()
    if $(this).text() == 'Edit me!'
      $(this).text 'Hide this'
      $(".addresspicker_input").show()
      $(".edit_place .r_submit").show()
      $(".editable").each ->
        $(this).removeAttr 'disabled'
        $(this).attr 'class': 'r_raw_field editable'
    else
      $(this).text 'Edit me!'
      $(".addresspicker_input").hide()
      $(".edit_place .r_submit").hide()
      $(".editable").each ->
        $(this).prop 'disabled', 'true'
        $(this).attr 'class': 'r_inv_field editable'
