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
# == ApplicationController Class Definition
#
# The ApplicationController for this website. It currently defines
# just a single extra helper method: current_user.
class ApplicationController < ActionController::Base
  # Let all the controllers include the methods froms Utils
  include Utils

  protect_from_forgery
  helper_method :current_user

  # Setting gettext locale
  before_filter :set_gettext_locale

  protected

  ##
  # Get the current logged in user.
  #
  # @return *User* The current logged in user, nil if there's
  # no currently logged in user.
  def current_user #:doc:
    if cookies[:auth_token]
      @current_user ||= User.find_by_auth_token!(cookies[:auth_token])
    end
  end

  ##
  # TODO
  def android_user
    if params[:auth_token]
      @current_user ||= User.find_by_auth_token!(params[:auth_token])
    end
  end
end
