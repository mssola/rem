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
  ##
  # The _new_ method. Initializes a new empty place.
  def new
    @place = Place.new
  end

  ##
  # The _create_ method. It creates a new route with the given parameters
  # passed by the new_place form.
  def create
    @place = Place.new(params[:place])
    @place.nroutes = 1
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
  # The _destroy_ method. It deletes all the info about a place and
  # redirects the user to the home page.
  def destroy
    Place.find(params[:id]).destroy
    redirect_to root_url, :notice => 'Place destroyed'
  end
end
