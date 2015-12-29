get "/" do
  @title = "温泉宿検索"
  @content = "Hello World!"
  slim :top
end

get "/search" do
  pass unless params[:prefecture] && params[:onsen_q]
  @title = "都道府県：#{params[:prefecture]}　泉質：#{params[:onsen_q]} - 温泉宿検索"
  @content = "Searched #{params[:prefecture]} #{params[:onsen_q]}"
  slim :index
end

get "/search" do
  @title = "温泉宿を検索 - 温泉宿検索"
  @content = "Search"
  slim :new
end
