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


module RemResponse
  def rem_created(row)
    msg = "#{row.class.to_s} created successfully"
    ca = row.created_at.strftime("%B %e, %Y")
    { status: 201, msg: msg, id: row.id, name: row.name, created_at: ca }
  end

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
