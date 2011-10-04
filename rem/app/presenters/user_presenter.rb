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


##
# == UserPresenter Class Definition
#
# This presenter connects the user model with the user account
# templates. It may sound weird since it's connecting two "different"
# things: the User and the Account. However, in my opinion the account
# is very related to the user so this kind of connection makes sense.
class UserPresenter < BasePresenter
  presents :user
  delegate :name, to: :user

  ##
  # Show how long this user is registered on our website.
  def member_since
    user.created_at.strftime("%e %B %Y")
  end
end
