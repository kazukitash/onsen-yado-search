require "net/http"
require "uri"

module Jalan
  BASE_API_URI  = "http://jws.jalan.net/"
  ONSEN_API_URI = BASE_API_URI + "APICommon/OnsenSearch/V1/"
  HOTEL_API_URI = BASE_API_URI + "APIAdvance/HotelSearch/V1/"

  def uri uri_str, query
    query_str = query.map { |k, v| URI.encode("#{k}=#{v}") }
    uri_str + "?key=#{Sinatra::Application.settings.jalan_key}&" + query_str.join("&")
  end

  def fetch uri_str, limit = 3
    raise ArgumentError, "HTTP redirect too deep" if limit == 0

    response = Net::HTTP.get_response(URI.parse(uri_str))
    case response
    when Net::HTTPSuccess
      response
    when Net::HTTPRedirection
      fetch(response["location"], limit - 1)
    else
      response.value
    end
  end

  def parse type, response
    xml = REXML::Document.new(response.body)
    results = {}
    results["DisplayFrom"]     = xml.elements["Results/DisplayFrom"].text.to_i
    results["DisplayPerPage"]  = xml.elements["Results/DisplayPerPage"].text.to_i
    results["NumberOfResults"] = xml.elements["Results/NumberOfResults"].text.to_i
    unless results["NumberOfResults"] == 0
      case type
      when :onsen
        results["Onsen"] = []
        xml.elements.each("Results/Onsen") do |o|
          onsen = {}
          onsen["OnsenID"]   = o.elements["OnsenID"].text
          onsen["OnsenName"] = o.elements["OnsenName"].text
          results["Onsen"].push onsen
        end
      when :hotel
        results["Hotel"] = []
        xml.elements.each("Results/Hotel") do |h|
          hotel = {}
          hotel["Rating"]            = h.elements["Rating"].text.to_f
          hotel["OnsenName"]         = h.elements["OnsenName"].text
          hotel["HotelName"]         = h.elements["HotelName"].text
          hotel["SmallArea"]         = h.elements["Area/SmallArea"].text
          hotel["PictureURL"]        = h.elements["PictureURL"].text
          hotel["Prefecture"]        = h.elements["Area/Prefecture"].text
          hotel["HotelCaption"]      = h.elements["HotelCaption"].text
          hotel["HotelDetailURL"]    = h.elements["HotelDetailURL"].text
          hotel["HotelCatchCopy"]    = h.elements["HotelCatchCopy"].text
          hotel["AccessInformation"] = []
          h.elements.each("AccessInformation") do |a|
            access = {}
            access["Name"]   = a.attributes["name"]
            access["Locale"] = a.text
            hotel["AccessInformation"].push access
          end
          results["Hotel"].push hotel
        end
      end
    end
    results
  end

  module_function :fetch, :uri, :parse
end
