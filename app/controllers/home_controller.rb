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
# == HomeController Class Definition
#
# Controller for the Home page.
class HomeController < ApplicationController
  ##
  # The _index_ method.
  def index
    unless current_user.nil?
      @routes = current_user.routes
      @user = current_user

      # Get all the activities of the people you're following (except yourself)
      # and then sort it in reverse order.
      following = @user.following.map { |u| u if u.id != @user.id }.compact
      @activities = []
      following.each { |f| @activities += f.activities }
      @activities.sort { |a, b| b.created_at <=> a.created_at }
    end
  end
end
