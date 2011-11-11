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


require 'fileutils'


module Uploader
  BASE = 'app/uploads'

  def handle_upload
    upload = params['media']
    user = User.find_by_auth_token!(cookies[:auth_token])
    tmp = upload.tempfile.path
    file = get_path(upload.original_filename, user)

    if file.class == String
      FileUtils.mv tmp, file
      { :status => :created }
    else
      { :status => file }
    end
  end

  def remove_from_bucket(file, user)
    return { :status => :unauthorized } if user.nil?

    m_base = File.join(BASE, user.id.to_s, file)
    return { :status => :notfound } unless File.exists?(m_base)
    FileUtils.rm(m_base)
    { :status => :created }
  end

  def get_path(filename, user)
    return :unauthorized if user.nil?

    m_basepath = File.join(BASE, user.id.to_s)
    FileUtils.mkdir(m_basepath) unless File.exists?(m_basepath)
    expected = File.join(m_basepath, filename)
    File.exists?(expected) ? :conflict : expected
  end
end
