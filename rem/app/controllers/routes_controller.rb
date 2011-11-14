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
  # *Rest API*
  #
  # The _create_ method. It creates a new route according to the params.
  def create
    @route = Route.new(params[:route])

    unless @route.nil? || current_user.nil?
      @route.user_id, @route.rating = current_user.id, 0
    end
    if @route.save && !current_user.nil?
      current_user.follow! @route
      respond_to do |format|
        format.json { render :json => rem_created(@route), status: 201 }
        format.xml  { render :xml => rem_created(@route), status: 201  }
        format.html { redirect_to edit_route_url(@route.id) }
      end
    else
      error = current_user.nil? ? 401 : 404
      error = 409 unless Route.find_by_name(@route.name).nil?
      respond_to do |format|
        format.json { render :json => rem_error(error), :status => error }
        format.xml  { render :xml => rem_error(error), :status => error }
        format.html { render 'new' }
      end
    end
  end

  ##
  # The _edit_ method. It edits an existing route identified by the id
  # passed via params.
  def edit
    @route = Route.find(params[:id])
  end

  ##
  # *Rest API*
  #
  # Shows the info about the route specified on the params variable
  # and can be accessed through /routes/:name. It will return an XML if
  # the url specifies it, otherwise it will return a JSON object.
  def show
    @route = Route.find_by_name(params[:name])
    raise ActionController::RoutingError.new('Not Found') if @route.nil?
    respond_to do |format|
      format.json { render :json => @route.to_json }
      format.any(:xml, :html) { render :xml => @route.to_xml }
    end
  end

  ##
  # The _destroy_ method. It deletes all the info about a route and
  # redirects the user to the home page.
  def destroy
    Route.find(params[:id]).destroy
    redirect_to root_url, :notice => 'Route destroyed'
  end
end
