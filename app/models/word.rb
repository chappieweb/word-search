class Word 

  def create_key_str(search_string)
    # take a string and create the regular expression to search on
    search_key="^[AEIOUaeiou]*(?:"
    search_string.each_char {|c| search_key ="#{search_key}#{c}[aeiouAEIOU]*"}
    search_key ="#{search_key}\\z)"
  end

  def create_segmented_list(phrase)
    # slice the word into all possible chunks, minimum of 2 characters.
    # example gkkl would be segmented into gk-kl (2 letter groups) gkk-l (3 letter groups)
    segmented_list = []
    min_segment_size = 2
    (min_segment_size..phrase.length).step(1) do |slice_size|
      (0..phrase.length-1).step(slice_size) do |slice_start| 
        seg_str = phrase.slice(slice_start,slice_size) 
        # if the last segment is < mmin_segment_size then append it to previous match
        if seg_str.length < min_segment_size
            seg_str = "#{segmented_list.last}#{seg_str}"
            segmented_list.pop
        end
        segmented_list << seg_str unless segmented_list.include?(seg_str)
      end 
      segmented_list << '<<< seperator >>>' #new segmentation attempt
      end
      segmented_list
  end

  def segment_matches(wordlist, phrase)
    # process the segmented list, all segments must match for a phrase match
    segmented_list = create_segmented_list(phrase)
    matched = [] 
    batch_match = []
    bad_match = false
    segmented_list.each_with_index  do |item,i| 
      if item == '<<< seperator >>>' # next attempt
          if !bad_match 
           batch_match.each {|bm| matched << bm}
           bad_match = false
           batch_match = []  
          end
      else
        matches = wordlist.grep(/#{create_key_str(item) }/)
        bad_match = true  if matches.empty?
        batch_match <<  matches
      end
    end
    matched
  end

  def cartprod(args)
    # modified version of http://www.ruby-doc.org/gems/docs/g/glymour-0.0.21/Object.html#method-i-cartprod
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
    complete_list =[] 
    phrases = cartprod(matched_words)
    phrases.each  do |phrase_words|
      line = "" 
      phrase_words.each do |word|
        line =  "#{line} #{word}" 
      end
      complete_list << line unless line.blank?
    end
    complete_list
  end

  def load_word_list(filename)
    wordlist = []
    begin
      File.open(filename, "r").each_line do |line|
      wordlist << line.chomp
    end
    rescue Exception => e
      raise "File not found" 
    end
    wordlist
  end

end
