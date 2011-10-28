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
# == Relationship Class Definition
#
# This is a model that allows users to track who is following who.
# It's used by the User model in a has_many-through relationship. In the
# database it's stored the follower id and the followed id. Due its
# simetry, you can also do the same but backwards. This property is used
# by the User model in order to implement an optimal DB access.
class Relationship < ActiveRecord::Base
  attr_accessible :followed_id

  # A relationship is a matter of two users: the follower and the followed
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'

  validates_presence_of :followed_id, :follower_id
end
