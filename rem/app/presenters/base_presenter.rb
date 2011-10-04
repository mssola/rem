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
# == BasePresenter Class Definition
#
# The Base class for all the presenters that may be implemented. It's
# as general as possible. On your presenter you can happily call template
# methods since this class implements the method_missing method to do
# so.
class BasePresenter
  ##
  # Constructor. It initializes its attributes so it can connect
  # the model with the template object.
  #
  # @param *Object* object A model that we want to present.
  #
  # @param *ActionView::Helper* template The template object.
  def initialize(object, template)
    @object, @template = object, template
  end

  private

  ##
  # Auxiliar class method that dynamically defines a getter for the
  # object type we are presenting. You should call this method at the
  # beginning of a subclass of this class.
  #
  # @param *Symbol* name The name of the object this presenter is presenting.
  def self.presents(name)
    define_method(name) { @object }
  end

  ##
  # TODO
  def markdown(text)
    # TODO
  end

  ##
  # Re-implementing the method_missing method. With this, this class will
  # bypass any unknown call to the template object. This is perfect if we
  # want to call template methods directly.
  #
  # @param *Variable Argument List* args The arguments to the missing method.
  #
  # @param *Block* block The block given to the missing method.
  def method_missing(*args, &block)
    @template.send(*args, &block)
  end
end
