
require "net/http"
require "uri"
require "json"

class NetService
  BASE_URL = "https://rails-event-system.onrender.com/"  # Ensure that the URL uses https://

  def self.get_resource(path)
    url = URI.join(BASE_URL, path)

    # Ensure HTTPS connection
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true  # Enable SSL for HTTPS connection
    http.read_timeout = 5 # Maximum time to wait for a response
    http.open_timeout = 5 # Maximum time to establish the connection

    puts "Requesting #{url}"

    request = Net::HTTP::Get.new(url)
    response = http.request(request)

    handle_response(response, url)
  rescue Timeout::Error
    puts "Timeout while connecting to #{url}"
    nil
  rescue StandardError => e
    puts "An error occurred: #{e.message}"
    nil
  end

  private

  def self.handle_response(response, url)
    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)
    else
      error_message = "Error fetching resource at #{url}: #{response.code} #{response.message}"
      puts error_message
      puts "Response body: #{response.body}" if response.body
      nil
    end
  end
end
