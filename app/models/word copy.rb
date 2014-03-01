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
        seg_str = phrase.slice(slice_start,slice_size) 
  Rails.logger.debug " *** segmented list #{seg_str} ***"
  


        segmented_list << seg_str unless segmented_list.include?(seg_str)
      end
      # take care of last chunk if it is too small
      if segmented_list.last.length < min_segment
        segmented_list[segmented_list.length-2] = "#{segmented_list[segmented_list.length-2]}#{segmented_list[segmented_list.length-1]}"
        
Rails.logger.debug "---Fixing---"
        segmented_list.pop
        Rails.logger.debug "??? fixed #{segmented_list.to_yaml}"
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
      Rails.logger.debug "item: #{item} i:#{i} matches:#{matches}"
      if matches.empty?
        bad_match = true
        break
      else
        matched <<  matches
      end
    end
    matched
  end

  def cartprod(args)
    result = [[]]
    while [] != args
      t, result = result, []
      b, *args = args
      t.each do |a|
        b.each do |n|
          result << a + [n]
        end
      end
    end
    result
  end

  def make_phrases(matched_words) 
    complete_list = []
    phrases = cartprod(matched_words)
    phrases.each  do |phrase_words|
      line = "" 
      phrase_words.each do |word|
        line =  "#{line} #{word}" 
      end
      complete_list << line
    end
    complete_list
  end

end
