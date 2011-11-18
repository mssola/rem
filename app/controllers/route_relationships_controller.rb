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
# == RouteRelationshipsController Class Definition
#
# This is the controller for the relationships. In particular, it
# handles when a user wants to follow/unfollow a route.
class RouteRelationshipsController < ApplicationController
  ##
  # The _create_ method. The user wants to follow a route. After
  # that, we redirect the user to the same page.
  def create
    @route = Route.find(params[:route_relationship][:followed_id])
    @owner = User.find(@route.user_id)
    current_user.follow!(@route)
    redirect_to "/#{@owner.name}/#{@route.id}"
  end

  ##
  # The _destroy_ method. The user wants to unfollow a route. We
  # redirect the user to the same page.
  def destroy
    @route = RouteRelationship.find(params[:id]).followed
    @owner = User.find(@route.user_id)
    current_user.unfollow!(@route)
    redirect_to "/#{@owner.name}/#{@route.id}"
  end
end
 
