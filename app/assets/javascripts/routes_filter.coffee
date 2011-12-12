#
# Handling the routes filter.
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


# Sanitize the route class, just returning: public, protected.
sanitize_class = (klass) ->
  str = klass.attr('class')
  return str.replace 'filter ', ''

# Filter the list of routes with the text on tje input field.
filter_text = (ctx) ->
  context = "#" + ctx.attr("id")
  actual = $(context + " .routes_filter .routes_list ." + window.vis)
  input = $(context + " .filter_field .r_raw_field").val()
  actual.each ->
    txt = $(this).text()
    if txt.match(input) == null
      $(this).hide()
    else
      $(this).show()

jQuery ->
  window.vis = "route"

  # Let's handle the clicking on the "tabs"
  $(".filter").click (e) ->
    e.preventDefault()
    meth = sanitize_class $(this)
    ctx = $(this).parents(".home_filter")
    id = "#" + ctx.attr("id")
    if meth == 'all'
      $(id + " .routes_list .route:hidden").show()
      window.vis = "route"
    else
      $(id + " .routes_list .route:visible").hide()
      $(id + " ." + meth).show()
      window.vis = meth
    filter_text(ctx)

  # In the input field, on keyup filter the text.
  $(".filter_field .r_raw_field").keyup ->
    ctx = $(this).parents(".home_filter")
    filter_text(ctx)
