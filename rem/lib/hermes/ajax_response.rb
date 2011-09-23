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
  # This module defines different and plausible ways to handle
  # Ajax responses. The idea is that this module is mixed-in the
  # AjaxRequest module so it learns how to set a proper response
  # to a given request.
  module AjaxResponse
    ##
    # *Hash* This is the attribute that contains a response. It contains
    # two items: value and dest.
    # - The _value_ field is where the response string is stored.
    # - The _dest_ field contains the destination of the response.
    attr_accessor :ajax_response

    ##
    # Initialize the ajax_response attribute.
    #
    # @param *String* dest The response destination.
    def init_response(dest)
      @ajax_response = { value: '', dest: dest }
    end

    ##
    # Sets the default uniqueness response with a given attribute.
    #
    # @param *String* attribute The involved attribute.
    def set_uniqueness_response(attribute)
      @ajax_response[:value] = "Sorry but this #{attribute} is not available!"
    end

    ##
    # Clears the ajax response attribute.
    def no_response
      @ajax_response[:value].clear
    end
  end
end
