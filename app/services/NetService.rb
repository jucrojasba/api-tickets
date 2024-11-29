require "net/http"
require "uri"
require "json"

class NetService
  BASE_URL = "https://rails-event-system.onrender.com"

  def self.get_resource(path)
    url = URI.join(BASE_URL, path)

    # Create HTTP connection with SSL enabled
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true  # Enable SSL

    # Skip SSL certificate verification (only for testing)
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

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
