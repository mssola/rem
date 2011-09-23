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
# == RemWidgets Module definition.
#
# This module is a namespace for all the special widgets this application
# has. These special widgets are just wrappers to normal ones (submit_tag, ...)
# but they have their properties (class, tabindex,...) properly defined
# so the style is automatically updated.
module RemWidgets
  ##
  # Wrapper to the submit_tag method from Rails. It just defines a submit_tag
  # with 'signin_submit' as its class and a tabindex of 6.
  #
  # @param *String* text The text of the submit button.
  def r_submit(text)
    submit_tag text, { :class => 'r_submit', :tabindex => '6' }
  end

  ##
  # This is a quite abstract wrapper. Basically it defines the field tag
  # you want with the needed properties.
  #
  # @param *Symbol* kind The kind of field tag. For example :text for a
  # text_field_tag definition.
  #
  # @param *String* name The name for this tag.
  def r_field(kind, name)
    aux = kind.to_s + '_field'
    method(aux + '_tag').call(name, nil, { :class => 'r_' + aux })
  end

  ##
  # This wrapper does not deal with style. It takes two arguments, with the
  # second one being optional. If it's passed just one argument, it will
  # try to fill the text of the label tag according to the name. What it
  # does, basically, is to capitalize the name and replace underscores with
  # whitespaces. This 'text-guessing' is not applied if a text is given
  # to this method. Plus, the final text for the label_tag will be translated.
  #
  # @param *Symbol* name The name of the label.
  #
  # @param *String* text The text shown by the label tag. (_optional_)
  def r_label(name, text = nil)
    text = name.to_s.capitalize.gsub('_', ' ') if text.nil?
    label_tag name, _(text)
  end
end
