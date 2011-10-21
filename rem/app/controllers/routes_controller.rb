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
# TODO
class RoutesController < ApplicationController
  ##
  # TODO
  def new
    @route = Route.new
  end

  ##
  # TODO
  def create
    @route = Route.new(params[:route])
    @route.user_id, @route.rating = current_user.id, 0
    if @route.save
      # TODO: redirect to edit page
      redirect_to root_url
    else
      render 'new'
    end
  end
end
