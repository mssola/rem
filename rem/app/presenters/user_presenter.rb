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
# == UserPresenter Class Definition
#
# This presenter connects the user model with the user account
# templates. It may sound weird since it's connecting two "different"
# things: the User and the Account. However, in my opinion the account
# is very related to the user so this kind of connection makes sense.
class UserPresenter < BasePresenter
  presents :user
  delegate :name, :email, :full_name, :location, to: :user

  ##
  # Show how long this user is registered on our website.
  def member_since
    user.created_at.strftime("%e %B %Y")
  end

  ##
  # Show a link to your website.
  #
  # @param *Boolean* link True to have it as a link.
  def website(link = false)
    handle_none user.url do
      unless link
        user.url
      else
        link_to(user.url, user.url)
      end
    end
  end

  ##
  # Show a link to your twitter account.
  #
  # @param *Boolean* link True to have it as a link.
  def twitter(link = false)
    handle_none user.twitter_name do
      unless link
        user.twitter_name
      else
        link_to(user.twitter_name, "http://twitter.com/#{user.twitter_name}")
      end
    end
  end

  ##
  # Show your bio.
  def bio
    handle_none user.bio { markdown user.bio }
  end

  private

  ##
  # Handle when we want to show an attribute that may not have been given.
  #
  # @param *String* value The attribute we want to show.
  def handle_none(value) #:doc:
    yield if value.present?
  end
end
