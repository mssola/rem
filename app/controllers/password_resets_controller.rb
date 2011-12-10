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
# == PasswordResetsController Class Definition
#
# This is the password resets controller. It handles the logic behind
# resetting passwords. It sends an email when the user wants to reset his
# password. Inside this email, there are some instructions about how
# to properly reset the password and an url pointing to the edit method.
# In the edit page the user will be able to change his password.
class PasswordResetsController < ApplicationController
  ##
  # The _create_ method. It's called when the user submitted the password
  # reset form. If everything is fine, it will send an email to the given
  # account with instructions inside on how to change his password and a link
  # pointing to the edit method.
  def create
    user = User.find_by_email(params[:email])
    user.send_password_reset if user
    redirect_to root_url, :notice => _('Email sent with password reset instructions.')
  end

  ##
  # The _edit_ method. It handles the logic behind the form for changing
  # the password.
  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end

  ##
  # The _update_ method. It's called when the user has submitted the edit
  # form. This method does the actual password resetting and finally
  # it redirects to the root url.
  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_url, :alert => _('Password reset has expired.')
    elsif @user.update_attributes(params[:user])
      redirect_to root_url, :notice => _('Password has been reset!')
    else
      render :edit
    end
  end

  ##
  # This method is called when the user is changing his password via
  # the account page.
  def auth_change
    if current_user && current_user.authenticate(params[:old_password])
      if current_user.update_attributes(params[:user])
        redirect_to account_url, :notice => 'Password updated successfully.'
      else
        redirect_to account_url, :alert => 'The password and its confirmation do not match.'
      end
    else
      redirect_to account_url, :alert => 'Dude, the old password you submitted is wrong.'
    end
  end
end
