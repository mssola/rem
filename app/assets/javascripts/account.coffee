#
# All the functions responsible for the Account Settings page.
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
# Sanitize the string id.
#
# @param String str The string to sanitize.
sanitize = (str) ->
  return str.replace /^account\/?/, ''


##
# Get the bucket that has some sort of relationship with the given string.
#
# @param String str The identifier string.
getBucket = (str) ->
  id = sanitize str
  if id.length == 0
    id = 'user_bucket'
  else
    id = id + '_bucket'
  return $("#account_page").find('fieldset[id=' + id + ']')

##
# On page load check the buckets we have to hide. Obviously, do nothing
# if this page has nothing to do with the account settings page.
$(document).ready ->
  path = location.pathname.slice(1, location.pathname.length)
  return unless path.match(/^account/)

  $("#account_tabs li").each ->
    e = $(this).find('a')
    if e.attr('href') != path
      getBucket(e.attr('href')).hide()


##
# Do the tabbing effect.
jQuery ->
  $("#account_tabs li").each ->
    $(this).click ->
      visible = $("fieldset:visible")
      path = $(this).find('a').attr('href')
      bucket = getBucket(path)

      # Handle tabs colouring
      $("li.selected").removeClass 'selected'
      $(this).addClass 'selected'

      return false if bucket.attr('id') == visible.attr('id')
      visible.hide()
      bucket.show()
      return false

