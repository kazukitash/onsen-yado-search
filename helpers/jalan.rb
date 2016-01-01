require 'net/http'
require 'uri'

module Jalan
  BASE_API_URI  = "http://jws.jalan.net/"
  ONSEN_API_URI = BASE_API_URI + "APICommon/OnsenSearch/V1/"
  HOTEL_API_URI = BASE_API_URI + "APIAdvance/HotelSearch/V1/"

  def uri uri_str, query
    query_str = query.map { |k, v| URI.encode("#{k}=#{v}") }
    uri_str + "?key=#{Sinatra::Application.settings.jalan_key}&" + query_str.join("&")
  end

  def fetch uri_str, limit = 3
    raise ArgumentError, 'HTTP redirect too deep' if limit == 0

    response = Net::HTTP.get_response(URI.parse(uri_str))
    case response
    when Net::HTTPSuccess
      response
    when Net::HTTPRedirection
      fetch(response['location'], limit - 1)
    else
      response.value
    end
  end

  module_function :fetch, :uri
end
