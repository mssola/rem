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
# The controller for the users. It can create new users through the Sign Up
# form. It can edit users through de dashboard and show users through the
# Rest API. A user can also delete his account so this controller must
# handle the destroy method too.
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
      if params[:remember_me]
        cookies.permanent[:auth_token] = @user.auth_token
      else
        cookies[:auth_token] = @user.auth_token
      end
      redirect_to root_url, :notice => _('Signed up!')
    else
      render 'new'
    end
  end

  ##
  # The _edit_ method. This method corresponds to the user's dashboard.
  def edit
    raise ActionController::RoutingError.new('Not Found') if current_user.nil?
    @user = User.find_by_name(params[:name])
  end

  ##
  # *Rest API*
  #
  # Shows the info about the user specified on the params variable
  # and can be accessed through /users/:name. It will return an XML if
  # the url specifies it, otherwise it will return a JSON object.
  def show
    @user = User.find_by_name(params[:name])
    raise ActionController::RoutingError.new('Not Found') if @user.nil?
    respond_to do |format|
      format.json { render :json => @user.to_json }
      format.any(:xml, :html) { render :xml => @user.to_xml }
    end
  end

  ##
  # The _destroy_ method. This method is called when the user decided to
  # delete his account. At this point, this method will destroy the
  # user on our database and delete the auth_token on the cookies.
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    cookies.delete(:auth_token)
    redirect_to root_url, :notice => _('Account deleted')
  end
end
