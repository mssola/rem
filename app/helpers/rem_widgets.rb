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
  #
  # @param *String* kind You can optionally specify a different class for
  # this submit button.
  #
  # @param *Hash* opts Some additional options you can pass to this method.
  def r_submit(text, kind = nil, opts = {})
    kind ||= 'r_submit'
    opts[:class] = kind
    submit_tag text, opts
  end

  ##
  # This is a quite abstract wrapper. Basically it defines the field tag
  # you want with the needed properties.
  #
  # @param *Symbol* kind The kind of field tag. For example :text for a
  # text_field_tag definition.
  #
  # @param *String* name The name for this tag.
  #
  # @param *String* klass The field class property.
  #
  # @param *String* value The value for this field. Default value of nil.
  def r_field(kind, name, klass = nil, value = nil)
    aux = kind.to_s + '_field'
    klass ||= 'r_' + aux
    method(aux + '_tag').call(name, value, class: klass)
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
  #
  # @param *Hash* opts Some additional options you can pass to this method.
  def r_label(name, text = nil, opts = {})
    text = name.to_s.capitalize.gsub('_', ' ') if text.nil?
    opts[:class] = 'r_label'
    label_tag name, _(text), opts
  end

  ##
  # TODO: Check how multiple elements can be spitted into the html
  # so we can embed in a single call both the check_box and the r_label
  def r_check(name, element = nil)
    element ||= name
    check_box_tag name, 1, params[element]
  end
end
