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
# == Route Class Definition
#
# This is the model that represents a route. It belongs to
# a user and may have multiple places.
class Route < ActiveRecord::Base
  # Let's play with mass-assignment.
  attr_accessible :name, :user_id, :desc, :protected, :rating

  # Getting some validations done.
  validates_presence_of :name, :user_id, :on => :create
  validates_uniqueness_of :name, :scope => :user_id
  validates_length_of :desc, :maximum => 160

  # The basic definition of a route is: something that belongs to a user
  # and represents a set of places.
  belongs_to :user
  has_many :places, dependent: :destroy

  # A route may be followed by a certain number of users.
  has_many :followers, through: :reverse_route_relationships, source: :follower
  has_many :reverse_route_relationships, foreign_key: 'followed_id',
                                         class_name: 'RouteRelationship',
                                         dependent: :destroy

  ##
  # Override the as_json method to limit the fields returned.
  #
  # @param *Hash* options Options passed to this method. Unused.
  def as_json(options = {})
    options ||= { except: [:updated_at], include: :places }
    super(options)
  end
end
