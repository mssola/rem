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
  # Check if exists in the database a user with the given info.
  #
  # @param *Hash* info A hash containing the info of a user.
  #
  # @return *Boolean* True if we guess that this user already
  # exists. False otherwise.
  def check_user_account(info)
    user = User.find_by_name(info['nickname'])
    user ||= User.find_by_email(info['email'])
    if user.nil? and info['urls']
      info['urls']['Twitter'].match /com\/(.+)$/
      user = User.find_by_twitter_name($1)
    end
    user
  end

  ##
  # Re-implementing the included class methods in order to let
  # Rails consider all the methods defined inside this module as
  # helpers of the ActionController::Base class.
  #
  # @param *Class* modul The class that is including this one.
  def self.included(m)
    return unless m < ActionController::Base
    m.helper_method :check_user_account
  end
end
