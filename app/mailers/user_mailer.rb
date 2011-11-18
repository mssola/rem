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
# == UserMailer Class Definition
#
# The User mailer.
class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  ##
  # Sends a password reset mail to the given user.
  #
  # @param *User* user The user we have to send the mail.
  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => 'Password Reset'
  end
end
