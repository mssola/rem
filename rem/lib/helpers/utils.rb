#
# Author:: Copyright (C) 2011  Miquel Sabaté (mikisabate@gmail.com)
# License::
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 3 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library.  If not, see <http://www.gnu.org/licenses/>.
#


##
# == Utils Module Definition
#
# This is a module that defines a set of methods that are useful
# all across this Rails application.
module Utils
  ##
  # Include all the methods related to OmniAuth
  include Omni

  ##
  # Checks if the given parameter is a valid email.
  #
  # @param *String* email The email to be checked.
  #
  # @return *Boolean* True if the parameter is really an email,
  # false otherwise.
  def valid_email?(email)
    /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/.match(email)
  end
end
