require "net/http"
require "uri"
require "json"

class NetService
  BASE_URL = "http://192.168.89.16:3000"

  def self.get_resource(path)
    url = URI.join(BASE_URL, path)
    http = Net::HTTP.new(url.host, url.port)

    puts "Requesting #{url}"

    request = Net::HTTP::Get.new(url)
    response = http.request(request)

    handle_response(response)
  end

  private

  def self.handle_response(response)
    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)
    else
      error_message = "Error: #{response.code} #{response.message}"
      raise StandardError, error_message
    end
  end
end
