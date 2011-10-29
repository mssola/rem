
require 'libxml'


module ResponseUtils
  include LibXML

  ##
  # Evaluate the response object into a JSON object or an XML.
  #
  # @param *Symbol* kind The kind of object we want to evaluate.
  def eval_response(kind)
    if kind == :xml
      res = XML::Document.string(response.body)
    else
      res = JSON.parse response.body
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
  def xml_compare(doc, element, should_eql)
    e = doc.find("//#{element}").first.inner_xml
    raise ArgumentError unless e == should_eql
  end
end 
