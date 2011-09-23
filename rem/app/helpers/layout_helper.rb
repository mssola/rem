#
# Author:: Copyright (C) 2011  Miquel Sabaté (mikisabate@gmail.com)
#
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
# == LayoutHelper Module definition.
#
# Acts as a namespace for helper methods that set variables to
# be used in the layout.
module LayoutHelper
  # So we can use the Rem widgets all over our templates.
  include RemWidgets

  ##
  # Sets the title of the page.
  #
  # @param *String* page_title The title of the page.
  #
  # @param *Boolean* show_title True if the title should be
  # shown at the page body, false otherwise.
  def title(page_title, show_title = false)
    content_for(:title) { h(page_title) }
    @show_title = show_title
  end

  ##
  # Getter of the _show_title_ attribute.
  #
  # @return *Boolean* True if the title should be shown at
  # the page body, false otherwise.
  def show_title?
    @show_title
  end

  ##
  # Sets the stylesheet of the page. This is a wrapper of
  # the stylesheet_link_tag method..
  #
  # @param *Argument* *List* args The args to pass to the
  # stylesheet_link_tag method.
  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  ##
  # Sets the javascript of the page. This is a wrapper of
  # the javascript_include_tag method. It also adds the following
  # Javascript libraries:
  # - jQuery
  # - jQuery UI
  #
  # @param *Argument* *List* args The args to pass to the
  # javascript_include_tag method.
  def javascript(*args)
    content_for(:head) { javascript_include_tag(*jquery_urls) }
    content_for(:head) { javascript_include_tag(*args) }
  end

  private

  ##
  # Returns an array containing the urls of the jQuery and jQuery UI libs.
  #
  # @return *Array* that contains the urls of the jQuery and jQuery UI libs.
  def jquery_urls #:doc:
    [ "https://ajax.googleapis.com/ajax/libs/jquery/1.6.3/jquery.min.js",
      "https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.min.js"]
  end
end
 
