#
# Author:: Copyright (C) 2011  Miquel Sabaté (mikisabate@gmail.com)
#
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
# == SearchHelper Module Definition
#
# This module is the responsible to provide methods that issue searches
# to the DB so we can show it then with the view.
module SearchHelper
  ##
  # Search users.
  #
  # @param *String* name The name or full_name of the user we are searching.
  def search_users(name)
    e = escape_params name
    User.find :all, conditions: ["name like ? or full_name like ?", e, e]
  end

  ##
  # Search routes.
  #
  # @param *String* route The name of the route we are searching.
  def search_routes(route)
    e = escape_params route
    Route.find :all, conditions: ["name like ? and protected = 'false'", e]
  end

  ##
  # Search users.
  #
  # @param *String* place The name of the place we are searching.
  def search_places(place)
    e = escape_params place
    Place.find(:all, conditions: ["name like ?", e]).select do |x|
      x.route.protected == false
    end
  end

  private

  ##
  # Escape the params passed via the search widget.
  #
  # @param *String* value The value given to the search widget.
  def escape_params(value) #:doc:
    '%' + value.gsub('%', '\%').gsub('_', '\_').gsub('\\', '\\\\') + '%'
  end
end
