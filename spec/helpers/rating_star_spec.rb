require File.expand_path("../../../helpers/rating_star", __FILE__)

describe "クチコミ評点" do
  it "0.0点" do
    rating = 0.0
    star, half_star, no_star = rating_star(rating)
    expect(star).to eq 0
    expect(half_star).to eq 0
    expect(no_star).to eq 5
  end

  it "2.5点" do
    rating = 2.5
    star, half_star, no_star = rating_star(rating)
    expect(star).to eq 2
    expect(half_star).to eq 1
    expect(no_star).to eq 2
  end

  it "6.0点" do
    rating = 6.0
    star, half_star, no_star = rating_star(rating)
    expect(star).to eq 5
    expect(half_star).to eq 0
    expect(no_star).to eq 0
  end
end
