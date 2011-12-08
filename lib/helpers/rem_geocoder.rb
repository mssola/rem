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


require 'net/http'
require 'uri'
require 'json'


##
# == RemGeocoder Module Definition
#
# Makes use of the Google geocoding service to reverse geocode with no
# need to store a record.
module RemGeocoder
  # The base url for the Google geocoding service.
  GOOGLE_BASE = 'http://maps.googleapis.com/maps/api/geocode/json?latlng='

  ##
  # This method provides the Google reverse geocoding service.
  #
  # @param *Array* latlng A two-sized array containing first the latitude
  # and second the longitude.
  #
  # @return *String* the most accurate address for the given
  # longitude-latitude pair.
  def reverse_geocode(latlng)
    uri = URI.parse(GOOGLE_BASE + latlng.join(',') + '&sensor=true')
    json = Net::HTTP.get uri
    res = JSON.parse json

    return '' if res['results'].empty?
    res['results'][0]['formatted_address']
  end
end
