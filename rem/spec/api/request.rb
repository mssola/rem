
require 'libxml'


##
# == Reqs Module Definition
#
# Helper module for Requests/Responses. It does get requests according
# to the Rest API specification and it returns a proper response object.
module Reqs
  include LibXML

  ##
  # Initialize the url where all the requests will point.
  #
  # @param *String* url A valid http url.
  def self.init(url)
    @url = URI.parse(url)
  end

  ##
  # Do a GET request according to the Rest API specification. It raises
  # a NoMethodError exception if the server responded a code different of 200.
  #
  # @param *String* path Relative path to the base url specified during
  # the initialization of this module.
  #
  # @return A JSON or an XML object.
  def self.do_get(path)
    res = Net::HTTP.start(@url.host, @url.port) { |http| http.get(path) }
    raise NoMethodError if res.code != '200'

    if path.end_with?('.xml')
      res = XML::Document.string(res.body)
    else
      res = JSON.parse res.body
    end
    res
  end

  ##
  # Compare an XML element value with the expected one. Raises an
  # ArgumentError if the element value hasn't the expected value.
  #
  # @param *XML::Document* doc The XML document.
  #
  # @param *String* element The element we are looking for.
  #
  # @param *String* should_eql The expected value for the given element.
  def self.xml_compare(doc, element, should_eql)
    e = doc.find("//#{element}").first.inner_xml
    raise ArgumentError unless e == should_eql
  end
end
