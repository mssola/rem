#
# Author:: Copyright (C) 2011  Miquel Sabaté (mikisabate@gmail.com)
# License::
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 3 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library.  If not, see <http://www.gnu.org/licenses/>.
#


##
# == PlaceValidator Class Definition
#
# This is the validator for the Place model. The validation consists
# in check if the name is nil or if the address was given. It's considered
# the address to be given either when the attribute address was given or
# the latitude and longitude were given.
class PlaceValidator < ActiveModel::Validator
  ##
  # Re-implement the validate method to perform this special validation.
  #
  # @param *Place* record The place that we have to validate.
  def validate(record)
    if record.name.nil?
      record.errors[:base] << 'You have to provide a name for this place'
    elsif record.route_id.nil?
      record.errors[:base] << 'You have to provide a route_id for this place'
    elsif !address_given?(record)
      record.errors[:base] << 'You have to provide an address for this place'
    end
  end

  private

  ##
  # Check if the address was given.
  #
  # @param *Place* record The place that we have to validate.
  #
  # @return *Boolean* True if the address was given. False otherwise.
  def address_given?(record)
    !record.address.nil? || !(record.longitude.nil? || record.latitude.nil?)
  end
end
 
