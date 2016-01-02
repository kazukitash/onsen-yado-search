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
    @h_count = 4

    query    = { reg: @reg, onsen_q: @onsen_q, start: params[:start].to_i, count: @o_count}
    response = Jalan.fetch(Jalan.uri(Jalan::ONSEN_API_URI, query))
    @results = Jalan.parse(:onsen, response)
    @results["Onsen"].each do |onsen|
      query = { o_id: onsen["OnsenID"], count: @h_count, xml_ptn: 1  }
      response = Jalan.fetch(Jalan.uri(Jalan::HOTEL_API_URI, query))
      onsen["HotelResults"] = Jalan.parse(:hotel, response)
    end

    page_info, @current_page, @max_page_size = page_status(@results, @o_count)
    reg_name     = settings.region_code.elements["Area/Region[@cd='#{@reg}']"].attributes["name"]
    onsen_q_name = settings.onsen_q.elements["Quality/Onsen[@cd='#{@onsen_q}']"].attributes["name"]
    @title  = "エリア：#{reg_name}　泉質：#{onsen_q_name} - 温泉宿検索"
    @header = "エリア：#{reg_name}　泉質：#{onsen_q_name}　#{page_info}"
    slim :index
  rescue Net::HTTPServerException => error
    settings.logger.error error
    settings.logger.error error.backtrace.join("\n")
    status 400
    html "400"
  rescue => error
    settings.logger.error error
    settings.logger.error error.backtrace.join("\n")
    status 500
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
    Jalan.activate_advanced_options @query, params
    response = Jalan.fetch(Jalan.uri(Jalan::HOTEL_API_URI, @query))
    @results = Jalan.parse(:hotel, response)

    if @results["NumberOfResults"] == 0
      response = Jalan.fetch(Jalan.uri(Jalan::HOTEL_API_URI, { o_id: @o_id, count: 1, xml_ptn: 1 }))
      results  = Jalan.parse(:hotel, response)
      @onsen_name = results["Hotel"][0]["OnsenName"]
    else
      @onsen_name = @results["Hotel"][0]["OnsenName"]
    end

    page_info, @current_page, @max_page_size = page_status(@results, @count)
    @title  = "#{@onsen_name} - 温泉宿検索"
    @header = "#{@onsen_name}　#{page_info}"
    slim :show
  rescue Net::HTTPServerException => error
    settings.logger.error error
    settings.logger.error error.backtrace.join("\n")
    status 400
    html "400"
  rescue => error
    settings.logger.error error
    settings.logger.error error.backtrace.join("\n")
    status 500
    html "500"
  end
end
