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
  validates_presence_of :name, :on => :create
  validates_uniqueness_of :name, :scope => :user_id
  validates_length_of :desc, :maximum => 160

  # Setting up the relationships with other tables.
  has_many :places # TODO: see the Place model
  belongs_to :user

  ##
  # Override the to_xml method to limit the fields returned
  #
  # @param *Hash* options Options passed to this method
  def to_xml(options = {})
    options.merge!(except: private_columns, include: :places)
    super(options)
  end

  ##
  # Override the as_json method to limit the fields returned.
  #
  # @param *Hash* options Options passed to this method. Unused.
  def as_json(options = {})
    options ||= { except: private_columns, include: :places }
    super(options)
  end

  private

  ##
  # Returns the most sensitive columns in this model
  def private_columns #:doc:
    [:updated_at]
  end
end
