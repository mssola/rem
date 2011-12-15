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
# == Place Class Definition
#
# This is the model that represents a place. It belongs to a route. It
# may have a name, a description, etc. but most importantly, this model
# is the one that will be gmapable. Therefore, it needs attributes such as
# longitude, latitude and address.
class Place < ActiveRecord::Base
  attr_accessible :name, :route_id, :desc, :longitude, :latitude,
                  :address, :nroutes, :locality, :country

  include Utils

  validates_with PlaceValidator, :on => :create
  validates_presence_of :name, :on => :create
  validates_uniqueness_of :name, :scope => :route_id
  validates_length_of :desc, :maximum => 160

  # A place only belongs to a single route.
  belongs_to :route

  # GMaps
  acts_as_gmappable
  include RemMaps

  # Geocoder
  geocoded_by :address
  after_validation :geocode, :if => :address_changed?

  ##
  # Override the as_json method to limit the fields returned.
  #
  # @param *Hash* options Options passed to this method. Unused.
  def as_json(options = {})
    options ||= { except: [:updated_at] }
    super(options)
  end

  ##
  # Get the places nearby this one.
  #
  # @param *User* cu The current user.
  #
  # @param *Integer* distance The distance in km where this method should
  # be aware of.
  def nearby(cu, distance)
    nearbys(km_to_miles(distance)).map do |n|
      user = User.find(Route.find(n.route_id).user_id)
      if user.id == cu.id || cu.bi_following?(user)
        n
      else
        nil
      end
    end.compact
  end
end
