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
# == RemMaps Module Definition
#
# A module that encapsulates all methods needed for models that are gmappable.
module RemMaps
  ##
  # The address is taken directly from the _address_ attribute.
  def gmaps4rails_address
    address
  end

  ##
  # This title follows a very specific and compressed format that
  # the Javascript code understands.
  def gmaps4rails_title
    "#{self.name}|/places/id/#{self.id}"
  end

  ##
  # The GMaps infowindow.
  def gmaps4rails_infowindow
    route = Route.find(self.route_id)
    path = "#{route.user_id}/#{route.id}/#{self.name}"
    if File.exists? Rails.root.to_s + "/app/uploads/#{path}.jpg"
      "/assets/#{path}.jpg"
    else
      "/assets/rem_user.png"
    end
  end
end
