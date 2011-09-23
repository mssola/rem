 
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
# == ErrorMessagesHelper Module definition
#
# It defines some helpers regarding to error handling that will be finally
# included to the ActionView::Helpers::FormBuilder class.
module ErrorMessagesHelper
  ##
  # Render error messages for the given objects. The :message and
  # :header_message options are allowed.
  #
  # @param *Argument* *List* objects The objects whose errors we
  # have to render.
  def error_messages_for(*objects)
    options = objects.extract_options!
    options[:header_message] ||= I18n.t(:'activerecord.errors.header',
                                        :default => 'Invalid Fields')
    options[:message] ||= I18n.t(:'activerecord.errors.message',
                                 :default =>
                                'Correct the following errors and try again.')
    messages = objects.compact.map { |o| o.errors.full_messages }.flatten
    unless messages.empty?
      content_tag(:div, :class => 'error_messages') do
        list_items = messages.map { |msg| content_tag(:li, msg) }
        content_tag(:h2, options[:header_message]) +
            content_tag(:p, options[:message]) +
            content_tag(:ul, list_items.join.html_safe)
      end
    end
  end

  ##
  # == FormBuilderAdditions Module Definition
  #
  # Acts as a namespace of the methods we're adding to the
  # ActionView::Helpers::FormBuilder class.
  module FormBuilderAdditions
    ##
    # Renders the error messages of the current object with
    # the specified options.
    #
    # @param *Hash* options The rendering options.
    def error_messages(options = {})
      @template.error_messages_for(@object, options)
    end
  end
end

# And finally we send our additions to the
# ActionView::Helpers::FormBuilder class.
ActionView::Helpers::FormBuilder.send(:include, ErrorMessagesHelper::FormBuilderAdditions)
