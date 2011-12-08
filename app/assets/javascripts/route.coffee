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


flash_light = (bool) ->
  if bool
    str = 'Route updated successfully!'
    $("#save_changes span").css 'color', 'green'
  else
    str = 'We weren\'t able to save your changes, sorry.'
    $("#save_changes span").css 'color', 'red'
  $("#save_changes span").text str
  $('#save_changes').delay(2000).fadeOut 'slow', ->
    $("#save_changes span").text ''


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
          flash_light true
        else
          flash_light false

  $(".ui-state-default").mousedown ->
    txt = $(this).text()
    id = $(this).attr("class").split(" ")[1]
    base = $(".idock_info .img_base").text()

    $(".idock_title").text $(this).text()
    $(".idock_info a").attr "href", "/places/id/" + id
    $(".idock_info img").attr "src", base + txt + ".jpg"
    $(".idock_info").show()
