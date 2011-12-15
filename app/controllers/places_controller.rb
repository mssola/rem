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
# == PlacesController Class Definition
#
# The controller for the places. It allows us to create/edit/destroy places.
class PlacesController < ApplicationController
  include Uploader
  include RemGeocoder

  ##
  # The _new_ method. Initializes a new empty place.
  def new
    (redirect_to root_url; return) if current_user.nil?

    @place = Place.new
    @routes = current_user.routes.map { |o| [o.name, o.id] }
  end

  ##
  # The _create_ method. It creates a new route with the given parameters
  # passed by the new_place form.
  def create
    @place = Place.new(params[:place])
    if @place.save
      create_activity! @place, 'created'
      redirect_to edit_route_url(current_user.name, @place.route_id),
                  :notice => 'Place created successfully'
    else
      redirect_to new_place_url, :alert => 'Place already exists'
    end
  end

  ##
  # The _edit_ method. It edits an existing place identified by the
  # id passed via params.
  def edit
    @place = Place.find(params[:id])
    @route = Route.find(@place.route_id)
    @img = Rails.root.to_s +
        "/app/uploads/#{@route.user_id}/#{@route.id}/#{@place.name}.jpg"
    @img = File.exists?(@img)
    @markers = @place.to_gmaps4rails
  end

  ##
  # The _update_ method. Can be called for the json format when best_in_place
  # is requesting it. Otherwise, the response format will be html.
  def update
    @place = Place.find(params[:id])

    respond_to do |format|
      if @place.update_attributes(params[:place])
        format.html { redirect_to map_place_url, :notice => 'Place updated successfully' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @place.errors.full_messages, :status => :unprocessable_entity }
      end
    end
  end

  ##
  # *Rest API*
  #
  # Shows the info about the place specified on the params variable
  # and can be accessed through /places/:name. See the API documentation
  # for further information.
  def show
    @place = Place.find_by_name(params[:name])
    raise ActionController::RoutingError.new('Not Found') if @place.nil?
    if Route.find(@place.route_id).protected and android_user.nil?
      handle_error(401)
    else
      respond_to { |f| f.json { render :json => @place.to_json } }
    end
  end

  ##
  # *Rest API*
  #
  # Uploads a photo given through params and creates a new place also
  # according to the given params. Please, take a look at the API documentation
  # for more info about uploading photos.
  def photos
    response, status = handle_upload
    respond_to { |f| f.json { render :json => response, status: status } }
  end

  ##
  # *Rest API*
  #
  # Deletes a photo specified via params. It also removes the place. Please
  # take a look at the API documentation for more info about deleting places.
  def delete_photos
    response, status = remove_photo!
    respond_to { |f| f.json { render :json => response, status: status } }
  end

  ##
  # The _destroy_ method. It deletes all the info about a place and
  # redirects the user to the home page.
  def destroy
    place = Place.find(params[:id])
    destroy_activity! place
    place.destroy
    redirect_to root_url, :notice => 'Place destroyed'
  end

  ##
  # *Rest API*
  #
  # Get the nearby locations from a given place. An optional parameter
  # _distance_ can be set. It can also be passed a pair of
  # longitude-latitude.
  def nearby
    # Do not access if the user is not authenticated
    (handle_error(401); return) if android_user.nil?

    dist = (params[:distance]) ? params[:distance].to_i : 1
    if params[:longitude].nil? || params[:latitude].nil?
      place = Place.find(params[:id])
      data = place.nearby(android_user, dist).to_json
    else
      addr = [params[:latitude], params[:longitude]]
      place = Place.create!(address: reverse_geocode(addr),
                            name: 'fake', route_id: -1)
      data = place.nearby(android_user, dist).to_json
      place.destroy
    end

    respond_to { |f| f.json { render :json => data } }
    rescue ActiveRecord::RecordNotFound; handle_error(404)
  end

  private

  ##
  # Helper method that calls respond_to with the given status.
  #
  # @param *Integer* status The HTTP status code.
  def handle_error(status) #:doc:
    respond_to do |format|
      format.json { render :json => rem_error(status), status: status }
    end
  end
end
