require File.expand_path("../../../app", __FILE__)

describe "じゃらんAPI" do
  it "温泉検索URIを作れる" do
    query = { reg: "01", onsen_q: "0" }
    request_uri = Jalan.uri(Jalan::ONSEN_API_URI, query)
    expect(request_uri).to eq "http://jws.jalan.net/APICommon/OnsenSearch/V1/?key=#{Sinatra::Application.settings.jalan_key}&reg=01&onsen_q=0"
  end

  it "ONSEN XMLがパースできる" do
    xml      = REXML::Document.new(File.open(File.expand_path("../../xml/onsen.xml", __FILE__)))
    response = Response.new(File.open(File.expand_path("../../xml/onsen.xml", __FILE__)))
    results  = Jalan.parse(:onsen, response)
    expect(results["DisplayFrom"]).to eq xml.elements["Results/DisplayFrom"].text.to_i
    expect(results["DisplayPerPage"]).to eq xml.elements["Results/DisplayPerPage"].text.to_i
    expect(results["NumberOfResults"]).to eq xml.elements["Results/NumberOfResults"].text.to_i
    expect(results["Onsen"][0]["OnsenID"]).to eq xml.elements["Results/Onsen[1]/OnsenID"].text
    expect(results["Onsen"][0]["OnsenName"]).to eq xml.elements["Results/Onsen[1]/OnsenName"].text
  end

  it "HOTEL XMLがパースできる" do
    xml      = REXML::Document.new(File.open(File.expand_path("../../xml/hotel.xml", __FILE__)))
    response = Response.new(File.open(File.expand_path("../../xml/hotel.xml", __FILE__)))
    results  = Jalan.parse(:hotel, response)
    expect(results["DisplayFrom"]).to eq xml.elements["Results/DisplayFrom"].text.to_i
    expect(results["DisplayPerPage"]).to eq xml.elements["Results/DisplayPerPage"].text.to_i
    expect(results["NumberOfResults"]).to eq xml.elements["Results/NumberOfResults"].text.to_i
    expect(results["Hotel"][0]["Rating"]).to eq xml.elements["Results/Hotel[1]/Rating"].text
    expect(results["Hotel"][0]["OnsenName"]).to eq xml.elements["Results/Hotel[1]/OnsenName"].text
    expect(results["Hotel"][0]["HotelName"]).to eq xml.elements["Results/Hotel[1]/HotelName"].text
    expect(results["Hotel"][0]["SmallArea"]).to eq xml.elements["Results/Hotel[1]/Area/SmallArea"].text
    expect(results["Hotel"][0]["PictureURL"]).to eq xml.elements["Results/Hotel[1]/PictureURL"].text
    expect(results["Hotel"][0]["Prefecture"]).to eq xml.elements["Results/Hotel[1]/Area/Prefecture"].text
    expect(results["Hotel"][0]["HotelCaption"]).to eq xml.elements["Results/Hotel[1]/HotelCaption"].text
    expect(results["Hotel"][0]["HotelDetailURL"]).to eq xml.elements["Results/Hotel[1]/HotelDetailURL"].text
    expect(results["Hotel"][0]["HotelCatchCopy"]).to eq xml.elements["Results/Hotel[1]/HotelCatchCopy"].text
    expect(results["Hotel"][0]["AccessInformation"][0]["Name"]).to eq xml.elements["Results/Hotel[1]/AccessInformation[1]"].attributes["name"]
    expect(results["Hotel"][0]["AccessInformation"][0]["Locale"]).to eq xml.elements["Results/Hotel[1]/AccessInformation[1]"].text
  end
end
