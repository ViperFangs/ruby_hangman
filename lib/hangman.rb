word_file = File.open('hangman_words.txt', 'r')

def extract_words_from_file(file)
  words = []
  until file.eof?
    current_word = file.readline.strip
    words.push(current_word) if current_word.length >= 5 && current_word.length <=12
  end
  return words
end

word_list = extract_words_from_file(word_file)

game_word = word_list.sample.split('')

p game_word