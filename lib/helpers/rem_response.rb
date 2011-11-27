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


##
# == RemResponse Module Definition
#
# This module is the responsible to return a proper response that will
# be sent as an XML or JSON object. Therefore, this module is only usable
# for calls sent via the Rest API.
module RemResponse
  ##
  # Create a response for the 200 http response (Ok)
  #
  # @param *Hash* opts Some additional rows.
  #
  # @return *Hash* the response for this situation. Only the _status_ field
  # is mandatory although the server may set up some other fields with
  # the given parameter _opts_.
  def rem_ok(opts = {})
    { status: 200 }.merge!(opts)
  end

  ##
  # Create a response for the 201 http response (Created).
  #
  # @param *ActiveRecord::Base* row This is the row we've created. It assumes
  # that it responds to the _name_, _created_at_ and _id_ methods.
  #
  # @return *Hash* the response for this situation. This hash has the
  # following fields: _status_, _msg_, _id_, _name_ and _created_at_.
  def rem_created(row)
    msg = "#{row.class.to_s} created successfully"
    ca = row.created_at.strftime("%B %e, %Y")
    { status: 201, msg: msg, id: row.id, name: row.name, created_at: ca }
  end

  ##
  # Create a response for a given error that we're facing.
  #
  # @param *Integer* status The HTTP status code.
  #
  # @return *Hash* the response for this situation, with just two fields:
  # _status_ (http status code) and _msg_ (some info about the error).
  def rem_error(status)
    res = { status: status }
    case status
    when 401
      res[:msg] = "You're not authorized to perform such operation."
    when 404
      res[:msg] = "Resource not found. This means that you\'re accessing" +
      " an invalid url or that you haven't provided the right parameters."
    when 409
      res[:msg] = "Conflict! Already in our database"
    end
    return res
  end
end
