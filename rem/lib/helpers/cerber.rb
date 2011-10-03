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
# == Cerber Class Definition
#
# Cerber is a singleton class that stores IP's. It's used to check if a given
# IP can be dangerous (i.e. it's trying to login repeatedly with incorrect
# parameters). This class should be initialized with all the other Rails
# initializers so you can configure how many attempts do you want a specific
# IP to have. The name is the catalan name for Kerberos, the guardian dog
# of the Hades according to greek mythology.
class Cerber
  ##
  # Initialize this class.
  #
  # @param *Integer* max The maximum number of attempts that a given
  # IP has before getting inserted into the blacklist.
  def self.init(max)
    @watched, @blacklist = {}, []
    @max = max
  end

  ##
  # Try to remove the given IP from the system.
  #
  # @param *String* ip The given IP.
  def self.remove_ip(ip)
    @watched.delete ip
    @blacklist.delete ip
  end

  ##
  # Checks if a given IP is on the blacklist or not. It also
  # keeps track of the number of attempts of this IP and it
  # should be used whenever the user with the given IP is doing
  # something wrong.
  #
  # @param *String* ip The given IP.
  #
  # @return *Boolean* false if the given IP is on the blacklist,
  # true otherwise.
  def self.should_continue?(ip)
    return false if @blacklist.include?(ip)

    actual = @watched[ip]
    if @watched[ip].nil?
      @watched[ip] = 1
    elsif @watched[ip] == @max
      @blacklist << ip
      return false
    else
      @watched[ip] += 1
    end
    true
  end
end
