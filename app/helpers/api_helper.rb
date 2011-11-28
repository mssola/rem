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
# == ApiHelper Module Definition
#
# This module provides methods that are useful to the API page views.
module ApiHelper
  ##
  # Return the provided file with some markup applied.
  #
  # @param *String* file The name of the file.
  def markdown(text)
    options = [:hard_wrap, :fenced_code, :gh_blockcode]
    syntax_highlighter(Redcarpet.new(text, *options).to_html).html_safe
  end

  ##
  # Highlights the given html code.
  #
  # @return *String* the highlighted string.
  def syntax_highlighter(html)
    doc = Nokogiri::HTML(html)
    doc.search("//pre[@lang]").each do |pre|
      pre.replace colorize(pre.text.rstrip, pre[:lang])
    end
    doc.to_s
  end

  ##
  # Colorize using Albino if the system has pygments. Otherwise we have
  # to issue an http post_form to a heroku app that provides pygments.
  #
  # @param *String* code The code we want to colorize.
  #
  # @param *String* lang The language.
  def colorize(code, lang)
    if can_pygmentize?
      Albino.colorize code, lang
    else
      Net::HTTP.post_form(URI.parse('http://pygmentize.herokuapp.com'),
                          { 'lang' => lang, 'code' => code }).body
    end
  end

  ##
  # Return true if the system has pygments. Return false otherwise.
  def can_pygmentize?
    system 'pygmentize -V'
  end
end
