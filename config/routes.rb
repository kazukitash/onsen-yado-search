get "/" do
  "Hello World!"
end

get "/search" do
  pass unless params[:prefecture] && params[:onsen_q]
  "Searched #{params[:prefecture]} #{params[:onsen_q]}"
end

get "/search" do
  "Search"
end
