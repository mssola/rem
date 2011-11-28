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


##
# == Uploader Module Definition
#
# This module is the responsible to upload photos and also to remove photos.
# When a photo is uploaded, it also creates a place with the attributes
# setted as expected. When we want to remove a photo, it also destroys the
# place containing it.
#
# Be aware that this module is expected to be mixed in a controller. This is
# because it needs to access to the params hash among other things.
module Uploader
  ##
  # To help on building the response hash.
  include RemResponse

  ##
  # Constant containing the base directory for the uploads.
  BASE = 'app/uploads'

  ##
  # This method handles the upload of a photo. In order to work properly,
  # we should have a current user authenticated and the params must be setted
  # accordingly. If the current user is not authenticated, it will just
  # return a 401 (Unauthorized) http response. It will return a 404 (Not found)
  # http response if the parameters passed are incorrect
  # (see Uploader#incorrect_params?). Moreover, it will return a 409 (Conflict)
  # http response if the given name (taking into account its full path) already
  # exists.
  #
  # If everything else is fine, we will get as a response a 201 (Created)
  # http response. It means that a place has been created in the database and
  # that the photo has been successfully stored in the server.
  #
  # @return *Array* a two-sized array. The first element is a *Hash* containing
  # at least the field _msg_ where it's stored a description of what happened.
  # The last element is an *Integer* that represents the HTTP response status.
  def handle_upload
    return [rem_error(401), 401] if android_user.nil?
    return [rem_error(404), 404] if incorrect_params?

    upload, route = params['media'], params['route_id']
    file = get_path(android_user, route, upload.original_filename)

    if file.is_a? String
      place = Place.create!(prepare_place(route.to_i,
                                          upload.original_filename))
      FileUtils.mv upload.tempfile.path, file
      return [rem_created(place), 201]
    end
    return [rem_error(file), file]
  end

  ##
  # This method removes a photo from the server and it also destroys the place
  # that contains this photo. In order to work, it will check if the current
  # user has been authenticated. If this fails, a 401 (Unauthorized) http
  # response will be returned. It will return a 404 (Not found) http response
  # whether the photo does not exist on the server or the place does not exist.
  #
  # If we reach this point, it means that the place will be successfully
  # destroyed and the photo will also be removed. The returned http response
  # in this case will be a 200 (Ok).
  #
  # @return *Array* a two-sized array. The first element is a *Hash* containing
  # at least the field _msg_ where it's stored a description of what happened.
  # The last element is an *Integer* that represents the HTTP response status.
  def remove_photo!
    return [rem_error(401), 401] if android_user.nil?

    place = Place.find(params['place_id'])
    m_file = place.name + '.jpg'
    m_base = File.join(BASE, android_user.id.to_s, place.route_id.to_s, m_file)
    return [rem_error(404), 404] unless File.exists?(m_base)

    place.destroy
    FileUtils.rm(m_base)
    [{ :msg => 'Place removed successfully' }, 200]

    rescue ActiveRecord::RecordNotFound; [rem_error(404), 404]
  end

  ##
  # Helper methods.

  ##
  # Given a user, a route and a file name, try to get the path for it.
  # We consider that this file does not exist yet, so if this is not the case,
  # this method will only return an Integer value of 409 (the Conflict http
  # status). Otherwise, it will create this file and all the directories if
  # necessary.
  #
  # @param *User* user The current user.
  #
  # @param *String* route The route id.
  #
  # @param *String* filename The original name for the uploaded file.
  #
  # @return *Integer* with value 409 if something went wrong. A *String*
  # containing the path of this file otherwise.
  def get_path(user, route, filename)
    m_basepath = File.join(BASE, user.id.to_s, route)
    FileUtils.mkdir_p(m_basepath) unless File.exists?(m_basepath)
    expected = File.join(m_basepath, filename)
    File.exists?(expected) ? 409 : expected
  end

  ##
  # Check if the given paramaters passed to the upload functionality are
  # correct. The parameters are correct if all of the following fields are
  # present in the params hash: media, longitude, latitude, route_id. Plus,
  # the user_id of the identified route must be the same as the current user's
  # id. If you don't understand this restrictions, please go to the API
  # documentation regarding to uploading photos.
  #
  # @return *Boolean* True if the parameters passed are incorrrect. False
  # otherwise.
  def incorrect_params?
    %w{media longitude latitude route_id}.each { |p| true if params[p].nil? }

    route = Route.find(params['route_id'])
    return (route.user_id != android_user.id)

    rescue ActiveRecord::RecordNotFound; return true
  end

  ##
  # Helper method that prepares the parameter passed to the Place#create!
  # method in order to create this new place in the database.
  #
  # @param *Integer* route The route id.
  #
  # @param *String* name The name for this place.
  #
  # @return *Hash* a hash containing the fields we can set right now.
  def prepare_place(route, name)
    name.match /(.+)\.(jpg)/
    {
      route_id: route, name: $1,
      longitude: params['longitude'], latitude: params['latitude']
    }
  end
end
