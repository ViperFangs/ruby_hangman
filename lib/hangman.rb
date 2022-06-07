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

def get_char
  begin
    char = gets.chomp 
    raise StandardError, 'Please enter a single character' if char.length > 1
    raise StandardError, 'Please enter an alphabet' unless char.to_i == 0
    char.downcase
  rescue StandardError => e
    puts e
    retry
  end
end

def play_game
  word_file = File.open('hangman_words.txt', 'r')
  secret_word = select_secret_word(word_file)
  guess_array = create_underscore_array(secret_word.length)
  puts secret_word.to_s

  until guess_array == secret_word
    
    current_char = get_char

    secret_word.each_with_index do |char, index|
      if current_char == char
        guess_array[index] = current_char
      end
    end
    puts guess_array.join(' ')
  end
end

play_game