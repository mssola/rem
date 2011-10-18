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
#     TODO
  # The _create_ method. It creates a new session for a user. This
  # method is called when the user clicked on of the log in buttons.
  # It also handles the cookies and if a given IP should be black-listed.
  def create
    auth = request.env['omniauth.auth']
    unless auth
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
        flash.now.alert = _('Invalid username, email or password')
        if Cerber.should_continue?(request.remote_ip)
          render 'new'
        else
          raise ActionController::RoutingError.new('Not Found')
        end
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

  private

  ##
  # Auxiliar method that finds a user by his email if the given parameter
  # is certaintly an email or otherwise by his username.
  #
  # @param *String* param a username or an email.
  def find_name_or_email(param)
    if valid_email? param
      User.find_by_email(param)
    else
      User.find_by_name(param)
    end
  end

  ##
  # Checks if the given parameter is a valid email.
  #
  # @param *String* email The email to be checked.
  #
  # @return *Boolean* True if the parameter is really an email,
  # false otherwise.
  def valid_email?(email)
    /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/.match(email)
  end

  ##
  # TODO
  def other_auth(hash)
    auth = Authentication.find_by_provider_and_uid(hash['provider'], hash['uid'])
    if auth.nil?
      info = hash['user_info']
      account = check_account info
      if account
        account.name = info['nickname'] if account.name == ""
        account.email = info['email'] if account.email == ""
        account.location = info['location'] if account.location == ""
        account.full_name = info['name'] if account.full_name == ""
        if info['urls']
          account.url = info['urls']['Website'] if account.url == ""
          account.twitter_name = info['urls']['Twitter'] if account.twitter_name == ""
        end
        account.authentications.create!(:provider => hash['provider'],
                                        :uid => hash['uid'],
                                        :user_id => account.id)
        account.save!
      else
        user = User.create_with_omniauth hash
      end
      auth = Authentication.find_by_provider_and_uid(hash['provider'], hash['uid'])
    end
    cookies.permanent[:auth_token] = auth.user.auth_token
    redirect_to root_url, :notice => _('Logged in!')
  end

  def check_account(info)
    user = User.find_by_name(info['nickname'])
    user ||= User.find_by_email(info['email'])
    if user.nil? and info['urls']
      info['urls']['Twitter'].match /com\/(.+)$/
      user = User.find_by_twitter_name($1)
    end
    user
  end
end
