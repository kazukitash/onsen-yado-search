require File.expand_path("../../app", __FILE__)

describe "Application" do
  def app
    Sinatra::Application
  end

  it "トップページにアクセスできる" do
    get "/"
    expect(last_response).to be_ok
  end

  it "検索ページにアクセスできる" do
    get "/onsen"
    expect(last_response).to be_ok
  end

  it "検索結果一覧ページにアクセスできる" do
    allow(Jalan).to receive(:fetch).and_return({})
    allow(Jalan).to receive(:parse).and_return({ "NumberOfResults" => 0, "DisplayFrom" => 0, "DisplayPerPage" => 0})
    get "/onsen", { reg: 01, onsen_q: 0, start: 1 }
    expect(last_response).to be_ok
  end

  it "検索結果一覧ページを表示するときに400エラーが起きたら400.htmlを表示する" do
    error = Net::HTTPServerException.new("400 Bad Request", Response.new(""))
    allow(Jalan).to receive(:fetch).and_raise(error)
    get "/onsen", { reg: 01, onsen_q: 0, start: 1 }
    expect(last_response.status).to eq 400
  end

  it "検索結果一覧ページを表示するときに500エラーが起きたら500.htmlを表示する" do
    allow(Jalan).to receive(:fetch).and_raise(StandardError.new)
    get "/onsen", { reg: 01, onsen_q: 0, start: 1 }
    expect(last_response.status).to eq 500
  end

  it "検索結果詳細ページにアクセスできる" do
    allow(Jalan).to receive(:fetch).and_return({})
    allow(Jalan).to receive(:parse).and_return({ "NumberOfResults" => 0, "DisplayFrom" => 0, "DisplayPerPage" => 0, "Hotel" => [{ "OnsenName" => "" }] })
    get "/onsen/0001"
    expect(last_response).to be_ok
  end

  it "検索結果詳細ページを表示するときに400エラーが起きたら400.htmlを表示する" do
    error = Net::HTTPServerException.new("400 Bad Request", Response.new(""))
    allow(Jalan).to receive(:fetch).and_raise(error)
    get "/onsen/0001"
    expect(last_response.status).to eq 400
  end

  it "検索結果詳細ページを表示するときに500エラーが起きたら500.htmlを表示する" do
    allow(Jalan).to receive(:fetch).and_raise(StandardError)
    get "/onsen/0001"
    expect(last_response.status).to eq 500
  end
end
