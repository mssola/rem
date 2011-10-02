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
# == SessionsController Class Definition
#
# NOTE: Under construction
class SessionsController < ApplicationController
  def new; end

  def create
    user = find_name_or_email(params[:name_or_email])
    if user && user.authenticate(params[:password])
      if params[:remember_me]
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token
      end
      Cerber.remove_ip request.remote_ip
      redirect_to root_url, :notice => _('Logged in!')
    else
      flash.now.alert = _('Invalid email or password')
      if Cerber.should_continue?(request.remote_ip)
        render 'new'
      else
        raise ActionController::RoutingError.new('Not Found')
      end
    end
  end

  def destroy
    cookies.delete(:auth_token)
    redirect_to root_url, :notice => _('Logged out!')
  end

  private

  def find_name_or_email(param)
    if valid_email? param
      User.find_by_email(param)
    else
      User.find_by_name(param)
    end
  end

  def valid_email?(email)
    /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/.match(email)
  end
end
