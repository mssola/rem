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
    name = params[:name].nil? ? params[:route] : { :name => params[:name] }
    @route = Route.new(name)

    current_user || android_user
    @route.user_id = @current_user.id unless @route.nil? || @current_user.nil?

    if !@current_user.nil? && @route.save
      @route.rating = 0
      @current_user.follow! @route
      respond_to do |format|
        format.json { render :json => rem_created(@route), status: 201 }
        format.xml  { render :xml => rem_created(@route), status: 201  }
        format.html { redirect_to edit_route_url(@current_user.name, @route.id) }
      end
    else
      msg = @route.errors.messages
      if !msg.empty? && msg[:name].first == 'has already been taken'
        error = 409
      else
        error = @current_user.nil? ? 401 : 404
      end

      respond_to do |format|
        format.json { render :json => rem_error(error), :status => error }
        format.xml  { render :xml => rem_error(error), :status => error }
        format.html { render 'new' }
      end
    end
  end

  ##
  # The _edit_ method. It edits an existing route identified by the id
  # passed via params of the user identified by the name passed via params.
  def edit
    @user = User.find_by_name(params[:name])
    @route = @user.routes.find(params[:route_id])
    @places = @route.places.sort do |a, b|
      # Sort handling nil values
      (a && b ) ? a <=> b : ( a ? -1 : 1 )
    end
    @markers = @places.to_gmaps4rails
  end

  ##
  # The _update_ method. Can be called for the json format when best_in_place
  # is requesting it. Otherwise, the response format will be html.
  def update
    @route = Route.find(params[:id])

    respond_to do |format|
      if @route.update_attributes(params[:route])
        format.html { redirect_to map_place_url, :notice => 'Route updated successfully' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @route.errors.full_messages, :status => :unprocessable_entity }
      end
    end
  end

  ##
  # *Rest API*
  #
  # Shows the info about the route specified on the params variable
  # and can be accessed through /routes/:name. It will return an XML if
  # the url specifies it, otherwise it will return a JSON object.
  def show
    route = Route.find_by_name(params[:name])
    raise ActionController::RoutingError.new('Not Found') if route.nil?

    if route.protected and android_user.nil?
      respond_to do |format|
        format.json { render :json => rem_error(401), status: 401 }
        format.any(:xml, :html) { render :xml => rem_error(401), status: 401 }
      end
    else
      respond_to do |format|
        format.json { render :json => route.to_json }
        format.any(:xml, :html) { render :xml => route.to_xml }
      end
    end
  end

  ##
  # *Rest API*
  #
  # The _destroy_ method. It deletes all the info about a route and
  # redirects the user to the home page.
  def destroy
    begin
      route = Route.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      error_occurred 404
      return nil
    end

    current_user || android_user
    if @current_user.nil?
      error_occurred 401
    elsif route.user_id != @current_user.id
      error_occurred 409
    else
      route.destroy
      respond_to do |format|
        format.json { render json: { 'msg' => 'Route destroyed', status: 200 }}
        format.xml { render xml: { 'msg' => 'Route destroyed', status: 200 } }
        format.html { redirect_to root_url, :notice => 'Route destroyed' }
      end
    end
  end

  ##
  # Show the followers for this route and redirect to the show_follow page.
  def followers
    @user = User.find_by_name(params[:name])
    @route = @user.routes.find(params[:id])
    @followers = @route.followers
    render 'show_follow'
  end

  ##
  # Update the index of the places of the currently shown route. This is
  # a method called via AJAX, so the response follows the JSON format.
  def update_places
    params['res'].each_with_index do |i, j|
      place = Place.find(i.to_i)
      unless place.update_attribute('index',  j)
        respond_to { |f| f.json { head 404 } }
      end
    end
    respond_to { |f| f.json { head :ok } }
  end
end
