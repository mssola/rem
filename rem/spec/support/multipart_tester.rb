
require 'net/http/post/multipart'
require 'addressable/uri'


module MPTester
  UP_PATH = Rails.root.join('spec', 'fixtures', 'uploader')

  def upload_fixture(path, name, opts = {})
    fix = UP_PATH.join(name)
    url = URI.parse("http://localhost:3000/#{path}?#{to_query_string(opts)}")

    res = nil
    File.open(fix) do |f|
      req = Net::HTTP::Post::Multipart.new url.path,
          'media' => UploadIO.new(f, 'image/png', name)
      res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
    end
    return res
  end

  def to_query_string(val)
    uri = Addressable::URI.new
    uri.query_values = val
    uri.query
  end
end
