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
# == UsersController Class Definition
#
# The controller for the users.
class UsersController < ApplicationController
  # This class responds to Ajax requests.
  include Hermes::AjaxRequest

  ##
  # The _new_ method. It corresponds to the signup page. It initializes
  # an empty user.
  def new
    @user = User.new
  end

  ##
  # The _create_ method. This method is called when a user has submitted
  # on the signup page. It creates this new user with the given parameters
  # available on the signup form. If everything is fine, it redirects the
  # user to his home page.
  def create
    @user = User.new(params[:user])
    if @user.save
      cookies[:auth_token] = @user.auth_token
      redirect_to root_url, :notice => _('Signed up!')
    else
      render 'new'
    end
  end

  ##
  # The _edit_ method. This method corresponds to the user's dashboard.
  def edit
    raise ActionController::RoutingError.new('Not Found') if current_user.nil?
  end

  ##
  # *Rest API*
  #
  # Shows the info about the user specified on the params variable
  # and can be accessed through /users/:name. It will return an XML if
  # the url specifies it, otherwise it will return a JSON object.
  def show
    @user = User.find_by_name(params[:name])
    respond_to do |format|
      format.json { render :json => @user.to_json }
      format.any(:xml, :html) { render :xml => @user.to_xml }
    end
  end
end