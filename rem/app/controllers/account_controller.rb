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
# == AccountController Class Definition
#
# The controller for the account settings.
class AccountController < ApplicationController
  ##
  # The _update_ method. It's called when the user wants to
  # update its settings on the account.
  def update
    if update_user
      redirect_to account_url, :notice => 'Configuration saved!'
    else
      render :action => 'edit', :error => 'Fuck'
    end
  end

  private

  ##
  # Update the user attributes.
  #
  # @return *Boolean* true if the attributes have been successfully
  # updated. False otherwise.
  def update_user
    attr = { email: params[:email], full_name: params[:full],
             location: params[:location], url: params[:website],
             twitter_name: params[:twitter]}
    current_user.update_attributes(attr)
  end
end
