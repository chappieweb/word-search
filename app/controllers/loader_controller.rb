class LoaderController < ApplicationController
  def index
    File.open("myfile.txt", "r").each_line do |line|
      json_data = parse_string_to_json(line)
      Rails.logger.debug "record is #{json_data.to_yaml}"
    end
    render nothing: true
  end

 
  def parse_string_to_json(string_in)
      selections  =  { "feature" => "#{string_in.match(/(\s[A-Z\s]* - [0-9]*\s)/).to_s.strip}",
          "date_range" => "#{string_in.scan(/[0-9][0-9]\/[0-9][0-9]/)[0]} - #{string_in.scan(/[0-9][0-9]\/[0-9][0-9]/)[1]}",
          "price" => "#{string_in.match(/([0-9.]*\z)/).to_s.strip}"
      }
      selections.to_json
  end
end
