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


$: << File.expand_path(File.dirname(__FILE__))
require 'ajax_response'
require 'ajax_request'


##
# This module acts as a namespace for all the other modules inside
# the Hermes world. Inside Hermes we will find the following modules:
#
# - AjaxRequest: to handle Ajax requests.
# - AjaxResponse: to define Ajax responses.
module Hermes
  ##
  # Gem's name.
  NAME = 'hermes'
  
  ##
  # Hermes is still under development.
  VERSION = '0.0.1'
  
  ##
  # Hermes is licensed under the GNU General Public License version 3.
  LICENSE = 'GPLv3+'

  ##
  # Hermes summary.
  SUMMARY = 'Sending Ajax everywhere!'

  ##
  # Hermes gem description.
  DESCRIPTION = 'A library that provides facilities for Ajax requests.'
end
