word_file = File.open('hangman_words.txt', 'r')

def select_secret_word(file)
  words = []
  until file.eof?
    current_word = file.readline.strip
    words.push(current_word) if current_word.length >= 5 && current_word.length <=12
  end
  return words.sample.split('')
end

def create_underscore_array(length)
  underscore_array = []
  length.times do 
    underscore_array.push('_')
  end
  underscore_array
end

secret_word = select_secret_word(word_file)
correct_guess_array = create_underscore_array(secret_word.length)


