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

  ##
  # The _new_ method. Initializes a new empty place.
  def new
    @place = Place.new
    @routes = Route.all(conditions: ['user_id=?', current_user.id]).map do |o|
      [o.name, o.id]
    end
  end

  ##
  # The _create_ method. It creates a new route with the given parameters
  # passed by the new_place form.
  def create
    @place = Place.new(params[:place])
    @place.nroutes = 1 unless @place.nil?
    if @place.save
      redirect_to root_url, :notice => 'Place created successfully'
    else
      render 'new'
    end
  end

  ##
  # The _edit_ method. It edits an existing place identified by the
  # id passed via params.
  def edit
    @place = Place.find(params[:id])
#     @json = Place.all.to_gmaps4rails
  end

  ##
  # *Rest API*
  #
  # Shows the info about the place specified on the params variable
  # and can be accessed through /places/:name. It will return an XML if
  # the url specifies it, otherwise it will return a JSON object.
  def show
    @place = Place.find_by_name(params[:name])
    raise ActionController::RoutingError.new('Not Found') if @place.nil?
    if Route.find(@place.route_id).protected and android_user.nil?
      respond_to do |format|
        format.json { render :json => rem_error(401), status: 401 }
        format.any(:xml, :html) { render :xml => rem_error(401), status: 401 }
      end
    else
      respond_to do |format|
        format.json { render :json => @place.to_json }
        format.any(:xml, :html) { render :xml => @place.to_xml }
      end
    end
  end

  ##
  # *Rest API*
  #
  # Uploads a photo given through params and creates a new place also
  # according to the given params. Please, take a look at the API documentation
  # for more info about uploading photos.
  def photos
    response = handle_upload
    respond_to do |format|
      format.json { render :json => response, status: response[:status] }
      format.any(:xml, :html) { render :xml => response, status: response[:status] }
    end
  end

  ##
  # *Rest API*
  #
  # Deletes a photo specified via params. It also removes the place. Please
  # take a look at the API documentation for more info about deleting places.
  def delete_photos
    response = remove_photo!
    respond_to do |format|
      format.json { render :json => response, status: response[:status] }
      format.any(:xml, :html) { render :xml => response, status: response[:status] }
    end
  end

  ##
  # The _destroy_ method. It deletes all the info about a place and
  # redirects the user to the home page.
  def destroy
    Place.find(params[:id]).destroy
    redirect_to root_url, :notice => 'Place destroyed'
  end
end
