# github.com/sra0ne/urlscan-screenshot

require 'uri'
require 'net/http'
require 'net/https'
require 'json'

WAIT_TIME = 10

def input_url
  puts 'Enter site URL:'
  gets.chomp
end

def send_request(url)
  uri = URI('https://urlscan.io/api/v1/scan/')
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  request = Net::HTTP::Post.new(uri)
  request['Content-Type'] = 'application/x-www-form-urlencoded'
  request['API-Key'] = ENV['urlsckey'] # Set an environment variable with your urlscan.io API key
  request.body = "url=#{url}"
  response = http.request(request)
  handle_response(response)
end

def handle_response(response)
  uuid = JSON.parse(response.body)['uuid']
  if response.code == '200'
    puts "#{JSON.parse(response.body)['message']} with UUID: #{uuid}"
    uuid
  else
    puts "Submission failed with status code: #{response.code} and error message #{response.body}"
    exit
  end
end

def retrieve_screenshot(uuid)
  sc_uri = URI("https://urlscan.io/screenshots/#{uuid}.png")
  http = Net::HTTP.new(sc_uri.host, sc_uri.port)
  http.use_ssl = true
  request = Net::HTTP::Get.new(sc_uri)
  sc_response = http.request(request)
  handle_screenshot_response(sc_response, uuid)
  save_result(uuid)
end

def handle_screenshot_response(sc_response, uuid)
  if sc_response.code == '200'
    File.open("#{uuid}.png", 'wb') do |file|
      file.write(sc_response.body)
      puts "Image saved as #{uuid}.png"
    end
  else
    puts "Error: Unable to retrieve this image. Status code: #{sc_response.code}"
    puts "Check the result at urlscan.io/result/#{uuid} Exiting..."
    exit
  end
end

def save_result(uuid)
  result_uri = URI("https://urlscan.io/api/v1/result/#{uuid}/")
  http = Net::HTTP.new(result_uri.host, result_uri.port)
  http.use_ssl = true
  request = Net::HTTP::Get.new(result_uri)
  result_response = http.request(request)

  if result_response.code == '200'
    File.open("#{uuid}-result.json", 'w') do |file|
      file.write(result_response.body)
      puts "Result saved as #{uuid}-result.json"
    end
  else
    puts "Error: Unable to retrieve result. Status code: #{result_response.code}"
    puts "Check the result at urlscan.io/result/#{uuid} Exiting..."
    exit
  end
end

def rerun
  loop do
    puts 'Type Y to send another URL or N to exit'
    choice = gets.chomp.upcase
    case choice
    when 'Y'
      url = input_url
      uuid = send_request(url)
      puts "Waiting #{WAIT_TIME} seconds before sending request for screenshot"
      sleep(WAIT_TIME)
      retrieve_screenshot(uuid)
    when 'N'
      exit
    else
      puts 'Invalid input,enter Y or N'
    end
  end
end

url = input_url
uuid = send_request(url)
puts "Waiting #{WAIT_TIME} seconds before sending request for screenshot"
sleep(WAIT_TIME)
retrieve_screenshot(uuid)
rerun
