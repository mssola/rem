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
# == ApplicationHelper Module Definition
#
# This module provides methods to help any view on our
# application.
module ApplicationHelper
  ##
  # Instantiate a new presenter.
  #
  # @param *Object* object The object we want to present.
  #
  # @oaram *ActionView::Helper* klass The template that we are
  # connecting to the given model. The default value for this is nil.
  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter if block_given?
    presenter
  end

  ##
  # Get the avatar from the current user. It will show the standard one
  # if the user has no email and it will search through Gravatar otherwise.
  #
  # @param *User* user The current user.
  def get_avatar_of(user, height = 20)
    url = (user.email.empty?) ? 'rem_user.png' : user.gravatar_url
    image_tag url, height: height.to_s
  end

  ##
  # Return true if the given user is the current one. Return false otherwise.
  #
  # @param *User* user The user we're checking.
  def current_user?(user)
    !current_user.nil? && current_user.id == user.id
  end

  ##
  # Return true if the given controller is the current one.
  # Return false otherwise.
  #
  # @param *String* controller The given controller.
  def current_controller?(controller)
    request.path_parameters[:controller] == controller
  end

  ##
  # Override the url_for method to ensure http when we're leaving
  # SSL only pages.
  def url_for(options = nil)
    if Hash === options
      options[:protocol] ||= 'http'
    end
    super(options)
  end
end
