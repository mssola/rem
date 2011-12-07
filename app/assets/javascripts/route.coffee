#
# Handles the sortable list in the route page.
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


flash_light = (str) ->
  alert str


jQuery ->
  $("ul, li").disableSelection()
  $("#places_sortable").sortable
    revert: true,
    stop: (event, ui) ->
      indexs = []
      $(".ui-state-default").each ->
        indexs.push $(this).attr("class").split(" ")[1]
      update_directions(indexs) # defined in road.js
      $("#save_changes").show() unless $("#save_changes").is(":visible")

  $("#save_changes").click (e) ->
    e.preventDefault()
    $.ajax
      url: '/ajax/update_places',
      data: { res: changes },
      type: "POST",
      complete: (xhr, status) ->
        if xhr.status == 200
          flash_light 'we fucking rock!'
        else
          flash_light 'ooops'
