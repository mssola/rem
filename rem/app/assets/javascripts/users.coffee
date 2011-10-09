#
# Author:: Copyright (C) 2011  Miquel Sabaté (mikisabate@gmail.com)
# License::
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


#= require rem.valid


# This is a trick to load the correct Rem object from CoffeeScript.
Rem = (if (typeof exports != "undefined" and exports != null) then exports else this)


# Let's see if the user chooses a username that is already picked up.
jQuery ->
  $("#user_name").blur ->
    if @value != ''
      $.ajax( url: 'ajax_request', data: { method: 'find_user_by_name('+@value+')', dest: 'existing_name' }, type: "GET" )


# Shows an error if there's something wrong with the given email.
jQuery ->
  $("#user_email").focusout ->
    string = Rem.Valid.email(@value)
    if string == ""
      $.ajax( url: 'ajax_request', data: { method: 'find_user_by_email('+@value+')', dest: 'email_error' }, type: "GET" )
    else
      $("#email_error").text(string)


# Convenient function to determine whether passwords match or not.
#
# @param String pass The password from #user_password.
# @param String confirm The confirmation from #user_password_confirmation.
password_error = (pass, confirm) ->
  if !Rem.Valid.is_empty(confirm) and !Rem.Valid.is_empty(pass)
    if confirm == pass
      $("#password_error").text 'Passwords match'
    else
      $("#password_error").text 'Passwords doesn\'t match'


# And finally we use this password_error function at password and
# password_confirmation on the keyup() event.

jQuery ->
  $("#user_password").keyup ->
    password_error(@value, $("#user_password_confirmation")[0].value)

jQuery ->
  $("#user_password_confirmation").keyup ->
    password_error($("#user_password")[0].value, @value)


