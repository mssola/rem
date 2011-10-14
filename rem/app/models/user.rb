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
# == User Class Definition
#
# This is the User model.
class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation,
                  :full_name, :twitter_name, :location, :url

  # Let's make some basic validation.
  validates_uniqueness_of :name, :email
  validates_presence_of :name, :email, :password, :password_confirmation,
                        :on => :create

  # Rails 3.1 goodie :)
  has_secure_password

  # Before creating the user, we should create an authorization token
  # for him.
  before_create do
    generate_token(:auth_token)
  end

  ##
  # This method uses the UserMailer in order to send a
  # password reset mail.
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  ##
  # Override the to_xml method to limit the fields returned
  #
  # @param *Hash* options Options passed to this method
  def to_xml(options = {})
    options.merge!(except: private_columns)
    super(options)
  end

  ##
  # Override the as_json method to limit the fields returned.
  #
  # @param *Hash* options Options passed to this method. Unused.
  def as_json(options = {})
    options ||= { except: private_columns }
    super(options)
  end

  private

  ##
  # Returns the most sensitive columns in this model
  def private_columns
    [:updated_at, :password_digest, :password_reset_token,
     :password_reset_sent_at, :auth_token]
  end

  ##
  # Generate an authorization token and assign it to the specified column.
  #
  # @param *Symbol* column The column where we'll store the generated token.
  def generate_token(column) #:doc:
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
end
