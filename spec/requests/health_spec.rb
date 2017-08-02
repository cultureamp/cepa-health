require "spec_helper"

describe CepaHealth do
  before(:each) do
    CepaHealth.clear_probes!
    CepaHealth.key = nil
  end

  it "should return a 200 OK for passing probes" do
    CepaHealth.register(:unique) { ["VeryUniqueTestIFear", true, ""] }

    get "/healthy.html"
    expect(response.code).to eq("200")
    expect(response.body).to match(/VeryUniqueTestIFear/)
  end

  it "should return a JSON representation for passing probes" do
    CepaHealth.register(:unique) { ["VeryUniqueTestIFear", true, ""] }

    get "/healthy.json"
    expect(response.code).to eq("200")
    expect(JSON.parse(response.body)).to eq([{
      "name" => "VeryUniqueTestIFear",
      "status" => true,
      "comment" => ""
    }])
  end

  it "should return a 500 Error for failing probes" do
    CepaHealth.register(:success) { ["VeryUniqueTestIFear", true, ""] }
    CepaHealth.register(:failure) { ["TotallyUniqueFailure", false, ""] }

    get "/healthy.html"
    expect(response.code).to eq("500")
    expect(response.body).to match(/TotallyUniqueFailure/)
  end

  it "should return a 404 if a key is set and not specified" do
    CepaHealth.register(:unique) { ["VeryUniqueTestIFear", true, "" ] }
    CepaHealth.key = 'stone'
    get "/healthy.html"
    expect(response.code).to eq("404")
    expect(response.body).to eq("")
  end

  it "should return successful if a key is set and specified" do
    CepaHealth.register(:unique) { ['VeryUniqueTestIFear', true, "" ] }
    CepaHealth.key = 'stone'

    get "/healthy.html", params: { key: "stone" }
    expect(response.code).to eq("200")
    expect(response.body).to match(/VeryUniqueTestIFear/)
  end

  it "should filter responses based on only parameter" do
    CepaHealth.register(:error1) { ['error1', false, ""] }
    CepaHealth.register(:error2) { ['error2', false, ""] }
    CepaHealth.register(:warn1) { ['warn1', true, ""] }
    CepaHealth.register(:warn2) { ['warn2', true, ""] }

    get "/healthy.html", params: { only: "error1,warn1" }
    expect(response.body).to match(/error1/)
    expect(response.body).to match(/warn1/)

    expect(response.body).not_to match(/error2/)
    expect(response.body).not_to match(/warn2/)
  end

  it "should filter responses based on except parameter" do
    CepaHealth.register(:error1) { ['error1', false, ""] }
    CepaHealth.register(:error2) { ['error2', false, ""] }
    CepaHealth.register(:warn1) { ['warn1', true, ""] }
    CepaHealth.register(:warn2) { ['warn2', true, ""] }

    get "/healthy.html", params: { except: "error1,warn1" }
    expect(response.body).not_to match(/error1/)
    expect(response.body).not_to match(/warn1/)

    expect(response.body).to match(/error2/)
    expect(response.body).to match(/warn2/)
  end
end
