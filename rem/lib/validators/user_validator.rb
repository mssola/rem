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
# == UserValidator Class Definition
#
# The Validator class for the User model.
class UserValidator < ActiveModel::Validator
  ##
  # Re-implement the validate method so it's not possible to create a user
  # with a reserved one.
  #
  # @param *User* record The record to validate.
  def validate(record)
    if reserved_names.include? record.name
      record.errors[:base] << "Username '#{record.name}' is not available."
    end
  end

  private

  ##
  # Return the reserved names for this model.
  def reserved_names
    %W(api about overview contact help login logout signup ajax_request account)
  end
end 
