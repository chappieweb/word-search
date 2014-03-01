require 'spec_helper'

describe Word do

  it "Should raise and error when file does not exist" do
    @words = Word.new
    expect { @words.load_word_list('wordes.txt') }.to raise_error
  end

   it "Should not raise and error when file exists" do
    @words = Word.new
    expect { @words.load_word_list('words.txt') }.to_not raise_error
  end

  it "Should return an array when file is provided" do
    @words = Word.new
    word_list = @words.load_word_list('words.txt') 
    expect(word_list.class).to be Array
  end

  it "Word list should not be empty" do
    @words = Word.new
    word_list = @words.load_word_list('words.txt') 
    expect(word_list.empty?).to be false
  end

  it "Should return a properly formatted search string" do
    @words = Word.new
    search_str = @words.create_key_str('xyz') 
    expect(search_str).to eq('^[AEIOUaeiou]*(?:x[aeiouAEIOU]*y[aeiouAEIOU]*z[aeiouAEIOU]*\\z)')
  end

  it "Should provide a proper segmented list for 3 character string" do
    @words = Word.new
    segmented_list = @words.create_segmented_list('xyz') 
    expected = ["xyz", "<<< seperator >>>", "<<< seperator >>>"]
    expect(segmented_list).to eq(expected)
  end
 
 it "Should provide a proper segmented list for real world string" do
    @words = Word.new
    segmented_list = @words.create_segmented_list('vvvsg') 
    expected =  ["vv", "vsg", "<<< seperator >>>", "vvv", "sg", "<<< seperator >>>", "vvvsg", "<<< seperator >>>", "<<< seperator >>>"]
    expect(segmented_list).to eq(expected)
  end

  it "Should provide a proper matches list for real world string mrt" do
    @words = Word.new
    word_list = @words.load_word_list('words.txt') 
    matches = @words.segment_matches(word_list, 'mrt') 
    expected =  [["emerita", "emirate", "mart", "merit"]]
    expect(matches).to eq(expected)
  end

  it "Should provide a proper matches list for real world string gkkl" do
    @words = Word.new
    word_list = @words.load_word_list('words.txt') 
    matches = @words.segment_matches(word_list, 'gkkl') 
    expected =  [["geek", "gook"], ["kale", "keel", "kilo", "koala", "kola"]]
    expect(matches).to eq(expected)
  end

  it "Should provide a proper matches list for real world string pgppgpk" do
    @words = Word.new
    word_list = @words.load_word_list('words.txt') 
    matches = @words.segment_matches(word_list, 'pgppgpk') 
    expected =  []
    expect(matches).to eq(expected)
  end

 it "Should provide a proper matches list for real world string vvvsg" do
    @words = Word.new
    word_list = @words.load_word_list('words.txt') 
    matches = @words.segment_matches(word_list, 'vvvsg') 
    expected =  [["viva"], ["visage"]]
    expect(matches).to eq(expected)
  end


 it "Should provide a proper matches list for real world string vvvsgv" do
    @words = Word.new
    word_list = @words.load_word_list('words.txt') 
    matches = @words.segment_matches(word_list, 'vvvsgv') 
    expected = [["viva"], ["eaves", "vase", "visa", "vise"], ["agave", "gave", "give", "guava"]]
    expect(matches).to eq(expected)
  end

  it "Should print the data properly formatted for vvvsgv" do
    @words = Word.new
    word_list = @words.load_word_list('words.txt') 
    matches = @words.segment_matches(word_list, 'vvvsgv') 
    phrases = @words.make_phrases(matches)
    expected = [" viva eaves agave", " viva eaves gave", " viva eaves give", " viva eaves guava", " viva vase agave", " viva vase gave", " viva vase give", " viva vase guava", " viva visa agave", " viva visa gave", " viva visa give", " viva visa guava", " viva vise agave", " viva vise gave", " viva vise give", " viva vise guava"]
    expect(phrases).to eq(expected)
  end

  it "Should print the data properly formatted for vvvsg" do
    @words = Word.new
    word_list = @words.load_word_list('words.txt') 
    matches = @words.segment_matches(word_list, 'vvvsg') 
    phrases = @words.make_phrases(matches)
    expected = [" viva visage"]
    expect(phrases).to eq(expected)
  end

 it "Should print the data properly formatted for pgppgpk" do
    @words = Word.new
    word_list = @words.load_word_list('words.txt') 
    matches = @words.segment_matches(word_list, 'pgppgpk') 
    phrases = @words.make_phrases(matches)
    expected = []
    expect(phrases).to eq(expected)
  end

   it "Should print the data properly formatted for gkkl" do
    @words = Word.new
    word_list = @words.load_word_list('words.txt') 
    matches = @words.segment_matches(word_list, 'gkkl') 
    phrases = @words.make_phrases(matches)
    expected = [" geek kale", " geek keel", " geek kilo", " geek koala", " geek kola", " gook kale", " gook keel", " gook kilo", " gook koala", " gook kola"]
    expect(phrases).to eq(expected)
  end

   it "Should print the data properly formatted for mrt" do
    @words = Word.new
    word_list = @words.load_word_list('words.txt') 
    matches = @words.segment_matches(word_list, 'mrt') 
    phrases = @words.make_phrases(matches)
    expected = [" emerita", " emirate", " mart", " merit"]
    expect(phrases).to eq(expected)
  end

end
