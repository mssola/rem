#
# Author:: Copyright (C) 2011  Miquel Sabaté (mikisabate@gmail.com)
# License::
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either 
# version 3 of the License, or (at your option) any later version.
# 
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
# 
# You should have received a copy of the GNU Lesser General Public 
# License along with this library.  If not, see <http://www.gnu.org/licenses/>.
#


module Hermes #:nodoc:
  ##
  # This module contains basically all the magic. It provides an entry point
  # for any Ajax request which is the method ajax_request. Right now, it
  # just knows how to validate the uniqueness of an attribute.
  module AjaxRequest
    # So it knows how to set the response properly.
    include AjaxResponse

    ##
    # Entry point for any Ajax request. It just calls auxiliar methods that do
    # the real hard job. If the requested method is invalid, a NoMethodError is
    # raised.
    def ajax_request
      init_response ajax_dest

      if ajax_method =~ /^find_(.+)_by_(.+)\((.+)\)$/
        validate_uniqueness $1.capitalize, $2, $3
      elsif ajax_method =~ /^list_(.+)_(.+)$/
        get_list_of $1, $2
      elsif ajax_method =~ /^list_(.+)$/
        get_list_of $1
      else
        raise NoMethodError, "'#{ajax_method}' is not a valid Ajax method!"
      end
    end

    private

    ##
    # Validates the uniqueness of a value for a given attribute
    # of the given class.
    #
    # @param *String* model The name of the model.
    #
    # @param *String* attribute The name of the attribute.
    #
    # @param *String* value The value for the given attribute.
    def validate_uniqueness(model, attribute, value) #:doc:
      klass = Kernel.const_get(model)

      set_uniqueness_response attribute
      no_response if klass.send('find_by_' + attribute, value).nil?
    end

    def get_list_of(model, cond = nil)
      if cond.nil?
        @ajax_response[:value] = current_user.send(model)
      else
        @ajax_response[:value] = current_user.send(model).where(cond => true)
      end
    end

    ##
    # Convenient method to determine the requested method.
    #
    # @return *String* the name of the requested method.
    def ajax_method #:doc:
      params[:method]
    end

    ##
    # Convenient method to determine to response destination.
    #
    # @return *String* the destination of the response.
    def ajax_dest #:doc:
      params[:dest]
    end
  end
end

