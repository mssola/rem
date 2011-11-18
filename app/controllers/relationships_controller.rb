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
# == RelationshipsController Class Definition
#
# This is the controller for the relationships. In particular, it
# handles when a user wants to follow/unfollow another user.
class RelationshipsController < ApplicationController
  ##
  # The _create_ method. The user wants to follow another user. After
  # that, we redirect the user to the same page.
  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    redirect_to "/#{@user.name}"
  end

  ##
  # The _destroy_ method. The user wants to unfollow another user. We
  # redirect the user to the same page.
  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    redirect_to "/#{@user.name}"
  end
end 
