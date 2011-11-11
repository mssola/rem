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
    return { status: 404 } if incorrect_params?

    upload, route = params['media'], params['route_id']
    file = get_path(current_user, route, upload.original_filename)

    if file.is_a? String
      Place.create! prepare_place(route.to_i, file)
      FileUtils.mv upload.tempfile.path, file
      file = :created
    end
    return { :status => file }
  end

  def remove_from_bucket(file, user)
    return { :status => :unauthorized } if current_user.nil?

    m_base = File.join(BASE, current_user.id.to_s, file)
    return { :status => 404 } unless File.exists?(m_base)
    FileUtils.rm(m_base)
    { :status => :created }
  end

  def get_path(user, route, filename)
    return :unauthorized if user.nil?

    m_basepath = File.join(BASE, user.id.to_s, route.to_s)
    FileUtils.mkdir_p(m_basepath) unless File.exists?(m_basepath)
    expected = File.join(m_basepath, filename)
    File.exists?(expected) ? :conflict : expected
  end

  def incorrect_params?
    %w{media longitude latitude route_id}.each { |p| true if params[p].nil? }

    route = Route.find(params['route_id'])
    return (route.user_id != current_user.id)

    rescue ActiveRecord::RecordNotFound; return true
  end

  def prepare_place(route, name)
    {
      route_id: route, name: name,
      longitude: params['longitude'], latitude: params['latitude']
    }
  end
end
