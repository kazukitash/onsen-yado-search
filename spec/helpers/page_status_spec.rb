require File.expand_path("../../../helpers/page_status", __FILE__)

describe "ページ情報" do
  before do
    @count = 10
  end

  it "全267件11件目から10件ずつ" do
    results = { "NumberOfResults" => 267, "DisplayFrom" => 11, "DisplayPerPage" => 10 }
    page_info, current_page, max_page_size = page_status(results, @count)
    expect(page_info).to eq "267件中11〜20件目の検索結果"
    expect(current_page).to eq 2
    expect(max_page_size).to eq 27
  end

  it "全267件261件目から10件ずつ" do
    results = { "NumberOfResults" => 267, "DisplayFrom" => 261, "DisplayPerPage" => 7 }
    page_info, current_page, max_page_size = page_status(results, @count)
    expect(page_info).to eq "267件中261〜267件目の検索結果"
    expect(current_page).to eq 27
    expect(max_page_size).to eq 27
  end

  it "全0件" do
    results = { "NumberOfResults" => 0, "DisplayFrom" => 0, "DisplayPerPage" => 0 }
    page_info, current_page, max_page_size = page_status(results, @count)
    expect(page_info).to eq "該当0件"
    expect(current_page).to eq 1
    expect(max_page_size).to eq 1
  end
end
