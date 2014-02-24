require 'spec_helper'

describe LoaderController do

  it "Should turn to json for first record" do
    expected = { 
        "feature"  => 'TXT MESSAGING - 250',
        "date_range"     => '09/29 - 10/28',
        "price"    => '4.99'
      }.to_json

    json_response = controller.parse_string_to_json("$4.99 TXT MESSAGING - 250 09/29 - 10/28 4.99")
    expect(expected).to eq(json_response)
  end 

  it "Should turn to json for second record" do
    expected = { 
        "feature"  => 'OTHER TXT MESSAGING - 2950',
        "date_range"     => '09/30 - 10/30',
        "price"    => '14.99'
      }.to_json

    json_response = controller.parse_string_to_json("$14.99 OTHER TXT MESSAGING - 2950 09/30 - 10/30 14.99")
    expect(expected).to eq(json_response)
  end 

end
