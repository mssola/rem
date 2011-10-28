# encoding: utf-8

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
# Fill the DB with some random data.
namespace :db do
  desc 'Fill database with sample data'
  task populate: :environment do
    puts "\033[32mLet's reset the DB !\033[0m"
    Rake::Task['db:reset'].invoke
    puts "\033[32mPopulating the User table\033[0m"
    make_users
    puts "\033[32mPopulating the Relationship table\033[0m"
    make_relationships
  end
end

##
# Create the users.
def make_users
  admin = User.create!(name: 'mssola', full_name: 'Miquel Sabaté',
                       email: 'mikisabate@gmail.com',
                       password: 'asd', password_confirmation: 'asd',
                       twitter_name: 'miquelssola')
  99.times do |n|
    full_name = Faker::Name.name
    name  = full_name.gsub(/\s/,'').downcase
    email = "example-#{n+1}@rem.com"
    password  = 'asd'
    user = User.create!(name: name, email: email, full_name: full_name,
                        password: password, password_confirmation: password)
    user.auth_token = nil
    user.save!
  end
end

##
# Create the relationships between the recently created users.
def make_relationships
  users = User.all
  user  = users.first
  following = users[1..50]
  followers = users[3..40]
  following.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end 
