get "/" do
  @title = "温泉宿検索"
  slim :top
end

get "/onsen" do
  pass unless params[:reg] && params[:onsen_q] && params[:start]
  @reg     = params[:reg]
  @onsen_q = params[:onsen_q]

  begin
    @o_count = 10
    o_query = { reg: @reg, onsen_q: @onsen_q, start: params[:start].to_i, count: @o_count}
    o_response = Jalan.fetch(Jalan.uri(Jalan::ONSEN_API_URI, o_query))
    @o_result = REXML::Document.new(o_response.body)
    @h_count = 4
    @h_results = []
    @o_result.elements.each("Results/Onsen") do |onsen|
      h_query = { o_id: onsen.elements["OnsenID"].text, count: @h_count, xml_ptn: 1  }
      h_response = Jalan.fetch(Jalan.uri(Jalan::HOTEL_API_URI, h_query))
      @h_results.push(REXML::Document.new(h_response.body))
    end

    page_info, @number_of_results, @current_page, @max_page_size = page_status(@o_result, @o_count)
    reg_name     = settings.region_code.elements["Area/Region[@cd='#{@reg}']"].attributes["name"]
    onsen_q_name = settings.onsen_q.elements["Quality/Onsen[@cd='#{@onsen_q}']"].attributes["name"]
    @title  = "エリア：#{reg_name}　泉質：#{onsen_q_name} - 温泉宿検索"
    @header = "エリア：#{reg_name}　泉質：#{onsen_q_name}　#{page_info}"
    slim :index
  rescue Net::HTTPServerException, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError => e
    html "400"
  rescue Net::HTTPError, Net::HTTPFatalError, Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, ArgumentError => e
    html "500"
  end
end

get "/onsen" do
  @title = "温泉宿を検索 - 温泉宿検索"
  slim :new
end

get "/onsen/:id" do
  start = params[:start] ||= 1
  @o_id = params[:id]

  begin
    @count = 10
    @query = { o_id: @o_id, start: start, count: @count, xml_ptn: 1 }
    activate_advanced_options @query, params
    response = Jalan.fetch(Jalan.uri(Jalan::HOTEL_API_URI, @query))
    @result = REXML::Document.new(response.body)

    page_info, @number_of_results, @current_page, @max_page_size = page_status(@result, @count)
    if @number_of_results == 0
      response = Jalan.fetch(Jalan.uri(Jalan::HOTEL_API_URI, { o_id: @o_id, count: 1, xml_ptn: 1 }))
      result = REXML::Document.new(response.body)
      @onsen_name = result.elements["Results/Hotel[1]/OnsenName"].text
    else
      @onsen_name = @result.elements["Results/Hotel[1]/OnsenName"].text
    end
    @title  = "#{@onsen_name} - 温泉宿検索"
    @header = "#{@onsen_name}　#{page_info}"
    slim :show
  rescue Net::HTTPServerException, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError => e
    html "400"
  rescue Net::HTTPError, Net::HTTPFatalError, Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, ArgumentError => e
    html "500"
  end
end
