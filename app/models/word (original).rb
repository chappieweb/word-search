class Word 

  def create_key_str(search_string)
    # take a string and create the regular expression to search on
    search_key="^[AEIOUaeiou]*(?:"
    search_string.each_char {|c| search_key ="#{search_key}#{c}[aeiouAEIOU]*"}
    search_key ="#{search_key}\\z)"
  end

  def create_segmented_list(phrase)
      # slice the word into all possible chunks
    segmented_list = []
    min_segment = 2
    (min_segment..phrase.length).step(1) do |slice_size|
      (0..phrase.length-1).step(slice_size) do |slice_start| 
        segmented_list << phrase.slice(slice_start,slice_size)
      end
      # take care of last chunk if it is too small
      if segmented_list.last.length < min_segment
        segmented_list[segmented_list.length-2] = "#{segmented_list[segmented_list.length-2]}#{segmented_list[segmented_list.length-1]}"
        segmented_list.pop
      end
    end
    segmented_list
  end

  def segment_matches(wordlist, phrase)
    segmented_list = create_segmented_list(phrase)
    
    matched=[]
    bad_match = false
    segmented_list.each_with_index  do |item,i| 
      matches = wordlist.grep(/#{create_key_str(item) }/)
      if matches.empty?
        bad_match = true
        break
      else
        matches.each {|m| matched << { word: m, position: i }}
      end
    end
    matched
  end




#   def lookfor_matches(wordlist, phrase, slice_size)
#     matched = []
#     (0..phrase.length-1).step(slice_size) do |slice_start| 
#       searcher = "#{phrase.slice(slice_start,slice_size)}"
#       if searcher.length >= 2 && searcher.length == slice_size
#         matches = wordlist.grep(/#{create_key_str(searcher) }/)
#         matches.each {|m| matched << { word: m, position: slice_start }} 
#       end
#     end
#     matched
#   end


# def oldlookfor_matches(wordlist, phrase)
#     # 
#     matched = []
#   #  (2..phrase.length).step(1) do |slice_size|
#     slice_size = 2
#  #     word_matched = []
#       (0..phrase.length-1).step(2) do |slice_start| 
#         searcher = "#{phrase.slice(slice_start,slice_size)}"
#         if searcher.length >= 2 && searcher.length == slice_size
#           search_for = create_key_str(searcher) 
#           matches = wordlist.grep(/#{search_for}/)
#           matches.each {|m| matched << { word: m, position: slice_start }
#         }    

#         end
#       end
#      # word_matched.uniq
#      # word_matched.reject! { |t| t.empty? }
#     #  matched << word_matched
#     #  word_matched = []
#    # end
#     # matched.uniq
#     # matched.reject! { |t| t.empty? }
#      Rails.logger.debug "word matched #{matched.to_yaml}"
#     matched
#   end


  def make_phrases(matched_words) 
    Rails.logger.debug "\n\n *** your matches are *** #{matched_words.to_yaml} ***\n\n"
    matched_words.each {|mw| Rails.logger.debug "Processing #{mw[:position]} #{mw[:word]}"}
    # phrases = []
    # list_size = matched_words.size
    # Rails.logger.debug "size: #{list_size}"
       position = -1
       prefix =""
       matched_words.each do |wrd| 

        pst =  wrd[:position].to_i
        if pst > position 
          position = wrd[:position].to_i
          prefix = "#{prefix} | #{wrd[:word]}"
          Rails.logger.debug "*New Line  #{prefix}*"
        end

        Rails.logger.debug "#{wrd[:word]}   p:#{position}"
          prefix = "#{prefix} | #{wrd[:word]}"
          Rails.logger.debug "#{prefix}"
       end


  end

end
