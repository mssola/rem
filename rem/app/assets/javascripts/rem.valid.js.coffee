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


# Do the exporting.
Rem = exports ? this


##
# @class Valid
#
# This class is meant to handle all kind of validations across
# the application.
Rem.Valid = {
  ##
  # Validates the format of an email.
  #
  # @param String email The email to validate its format.
  # @return Boolean True if the format of the given email is a valid,
  # false otherwise.
  format: (email) ->
    cond = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/
        .test(email)

  ##
  # Checks if the given value is empty.
  #
  # @param String value The given value.
  # @return Boolean True if the given value is empty, false otherwise.
  is_empty: (value) ->
    value == "";

  ##
  # Validates an email.
  #
  # @param String value The email to validate.
  # @return String An empty string if everything is fine, otherwise
  # the string will contain a description of the error.
  #
  email: (value) ->
    if @is_empty(value)
      return "Can't be blank."
    else return "Invalid email."  unless @format(value)
    ""
}

