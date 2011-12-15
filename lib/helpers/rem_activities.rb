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
# == RemActivities module description
#
# Defines a helper method that creates activities.
module RemActivities
  ##
  # Create an activity.
  #
  # @param *ActiveRecord::Base* model The implied model.
  #
  # @param *String* action The action (created/destroyed, followed/unfollowed)
  #
  # @param *Integer* owner The id of the integer.
  def create_activity!(model, action, owner = nil)
    if model.is_a? Route
      return if model.protected == true
      mention = "r#{model.id}"
      owner ||= model.user_id
      opts = { user_id: owner, mention: mention,
               action: action, mention_id: model.id, mention_name: model.name }
    elsif model.is_a? Place
      mention = "p#{model.id}"
      route = Route.find(model.route_id)
      opts = { user_id: route.user_id, mention: mention,
               action: action, mention_id: model.id, mention_name: model.name }
    else
      mention = "u#{model.id}"
      owner ||= model.id
      opts = { user_id: owner, mention: mention,
               action: action, mention_id: model.id, mention_name: model.name }
    end
    Activity.create!(opts)
  end

  # TODO
  def destroy_activity!(model)
    Activity.update_by_sql("UPDATE activities SET destr = true WHERE mention_id = #{model.id} AND mention_name = #{model.name}")
  end
end
