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
  force_ssl
  helper_method :current_user

  # Setting gettext locale
  before_filter :set_gettext_locale

  # Handle ActiveRecord::RecordNotFound exceptions.
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

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
  # Get the current logged in Android user.
  #
  # @return *User* The current logged in Android user or nil if there's
  # no currently logged in Android user.
  def android_user #:doc:
    if params[:auth_token]
      @current_user ||= User.find_by_auth_token!(params[:auth_token])
    end
  end

  ##
  # Helper method that performs a response for a rem error.
  #
  # @param *Integer* status The Http status code.
  def error_occurred(status) #:doc:
    respond_to do |format|
      format.json { render json: rem_error(status), status: status }
      format.xml  { render xml: rem_error(status), status: status }
    end
  end

  ##
  # Called whenever ActiveRecord::RecordNotFound is raised.
  def record_not_found
    render "#{Rails.root}/public/404.html"
  end
end
