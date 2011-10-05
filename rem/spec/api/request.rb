
module Request
  def self.init(url)
    @url = URI.parse(url)
  end

  def self.do_get(path)
    res = Net::HTTP.start(@url.host, @url.port) { |http| http.get(path) }
    JSON.parse res.body
  end
end
