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
# == RoutesController Class Definition
#
# The controller for the routes. It allows us to create/edit/destroy routes
# and in the future it will bring some API methods.
class RoutesController < ApplicationController
  ##
  # The _new_ method. Initializes a new empty route.
  def new
    @route = Route.new
  end

  ##
  # The _create_ method. It creates a new route according to the params
  # passed by the new view.
  def create
    @route = Route.new(params[:route])
    @route.user_id, @route.rating = current_user.id, 0
    if @route.save
      redirect_to edit_route_url(@route.name)
    else
      render 'new'
    end
  end

  ##
  # The _edit_ method. It edits an existing route identified by the id
  # passed via params.
  def edit
    @route = Route.find(params[:id])
  end

  ##
  # The _destroy_ method. It deletes all the info about a route and
  # redirects the user to the home page.
  def destroy
    Route.find(params[:id]).destroy
    redirect_to root_url, :notice => 'Route destroyed'
  end
end
