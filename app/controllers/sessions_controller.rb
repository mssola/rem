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
# The controller for the sessions. It keeps track if a given user
# is logging in or logging out. It stores the authentication
# token to the cookies. Plus, if a given IP is failing too much
# at logging in, this IP is black-listed for security reasons.
class SessionsController < ApplicationController
  ##
  # The _new_ method. It does nothing.
  def new; end

  ##
  # The _create_ method. It creates a new session for a user. This
  # method is called when the user clicked on of the log in buttons.
  # It also handles the cookies and if a given IP should be black-listed.
  def create
    auth = request.env['omniauth.auth']
    unless auth
      user = find_name_or_email(params[:name_or_email])
      begin
        if user && user.authenticate(params[:password])
          if params[:remember_me]
            cookies.permanent[:auth_token] = user.auth_token
          else
            cookies[:auth_token] = user.auth_token
          end
          Cerber.remove_ip request.remote_ip
          redirect_to root_url, :notice => _('Logged in!')
        else
          flash.now.alert = _('Invalid username, email or password')
          if Cerber.should_continue?(request.remote_ip)
            render 'new'
          else
            raise ActionController::RoutingError.new('Not Found')
          end
        end
      rescue BCrypt::Errors::InvalidHash
        flash[:alert] = _('Login with another service')
        render 'new'
      end
    else
      other_auth auth
    end
  end

  ##
  # The _destroy_ method. It deletes the authentication token on the
  # cookies and redirects the user to the root url.
  def destroy
    cookies.delete(:auth_token)
    redirect_to root_url, :notice => _('Logged out!')
  end

  ##
  # *Rest API*
  #
  # It creates a new session for an Android user by returning the
  # auth_token in a json/xml object.
  def android
    if params['name'].nil? || params['password'].nil?
      error_occurred(404)
    else
      u = User.find_by_name(params['name'])
      if u.nil?
        error_occurred(401)
      else
        hash = BCrypt::Engine.hash_secret(params['password'], u.password_digest)
        if hash == u.password_digest
          res = rem_ok(auth_token: u.auth_token)
          respond_to do |format|
            format.json { render json: res, status: 200 }
            format.xml  { render xml: res, status: 200 }
          end
        else
          error_occurred(404)
        end
      end
    end
  end

  private

  ##
  # Auxiliar method that finds a user by his email if the given parameter
  # is certaintly an email or otherwise by his username.
  #
  # @param *String* param a username or an email.
  def find_name_or_email(param) #:doc:
    if valid_email? param
      User.find_by_email(param)
    else
      User.find_by_name(param)
    end
  end

  ##
  # Authenticate via another service such as Twitter or Google/OpenId.
  # The authentication will set the auth_token to a permanent cookie. If the
  # user was not found, a new account will be created.
  #
  # @param *Hash* h The hash with all the authentication details.
  def other_auth(h) #:doc:
    auth = Authentication.find_by_provider_and_uid(h['provider'], h['uid'])
    if auth.nil?
      info = h['user_info']
      account = check_user_account info
      if account
        account.name = info['nickname'] if account.name == ""
        account.email = info['email'] if account.email == ""
        account.location = info['location'] if account.location == ""
        account.full_name = info['name'] if account.full_name == ""
        if info['urls']
          account.url = info['urls']['Website'] if account.url == ""
          account.twitter_name = info['urls']['Twitter'] if account.twitter_name == ""
        end
        ah = { provider: h['provider'], uid: h['uid'], user_id: account.id }
        account.authentications.create!(ah)
        account.save!
      else
        user = User.create_with_omniauth h
      end
      auth = Authentication.find_by_provider_and_uid(h['provider'], h['uid'])
    end
    cookies.permanent[:auth_token] = auth.user.auth_token
    redirect_to root_url, :notice => _('Logged in!')
  end

  ##
  # Helper method that performs a response for a rem error.
  #
  # @param *Integer* status The Http status code.
  def error_occurred(status)
    respond_to do |format|
      format.json { render json: rem_error(status), status: status }
      format.xml  { render xml: rem_error(status), status: status }
    end
  end
end
