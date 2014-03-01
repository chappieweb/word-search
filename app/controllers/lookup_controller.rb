class LookupController < ApplicationController
  def create
    twwtr_entry = params[:lookup][:selected_twwtr]

    @words = Word.new
    wordlist = @words.load_word_list('words.txt')
    matches = @words.segment_matches(wordlist,twwtr_entry)
    completed_matches = @words.make_phrases(matches) 
    response_data=""
    completed_matches.each {|row| response_data = "#{response_data}<br>#{row}"}
    response_message = "Your search resulted in #{completed_matches.count} matching phrases"  
    respond_to do |format|
      format.js {render :locals => { :response_data => response_data, 
                                     :response_message => response_message}
                                    }
    end
  end
end
