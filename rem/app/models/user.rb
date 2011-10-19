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
  # These are the attributes ready for mass-assignment.
  attr_accessible :name, :email, :password, :password_confirmation,
                  :full_name, :twitter_name, :location, :url

  # Let's make some basic validation.
  validates_uniqueness_of :name, :email
  validates_presence_of :name, :on => :create
  validates_presence_of :email, :password, :password_confirmation,
                        :password_digest, on: :create, :if => :is_rem?

  # If a user is destroyed, it should delete also the dependent
  # rows in the authentications table.
  has_many :authentications, :dependent => :delete_all

  # Rails 3.1 goodie :)
  has_secure_password

  # Perform some actions before creating/validating a user.
  before_create { generate_token(:auth_token) }
  before_validation :password_required?

  # We want Gravatar support :)
  include Gravtastic
  gravtastic :secure => true

  ##
  # Create a brand new user from an external service.
  #
  # @param *Hash* auth This is a hash with important info related to
  # this new user. It follows the OAuth format.
  def self.create_with_omniauth(auth)
    info = auth['user_info']
    urls = cleanup_urls(info['urls'])
    create! do |user|
      user.name = info['nickname']
      user.name ||= info['name'] + rand(1000).to_s
      user.email = info['email']
      user.full_name = info['name']
      user.location = info['location']
      user.url = urls[:site]
      user.twitter_name = urls[:twitter]
      user.authentications.build(provider: auth['provider'], uid: auth['uid'])
    end
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
  def private_columns #:doc:
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

  ##
  # Is this a rem account signup ?
  #
  # @return *Boolean* True if this is a rem account, false otherwise.
  def is_rem? #:doc:
    return true if self.authentications.nil? || self.authentications.empty?
    self.authentications.each do |auth|
      return true if auth.provider == ""
    end
    false
  end

  ##
  # If the password is not required, tell the password_digest attribute
  # to shut up. Do nothing if this is a Rem account, so this digest
  # attribute can properly complain.
  def password_required? #:doc:
    unless authentications.empty? || !password.blank?
      self.password_digest = 0
    end
  end

  ##
  # Prepare a hash with the urls stripped for the user.
  #
  # @param *Hash* urls The urls given by the external service.
  #
  # @return *Hash* An empty hash if no urls is given at all. Otherwise
  # it will return a two-sized hash with the :site and :twitter keys.
  def self.cleanup_urls(urls) #:doc:
    return {} if urls.nil?
    urls['Twitter'].match /com\/(.+)$/
    { :site => urls['Website'], :twitter => $1 }
  end
end
