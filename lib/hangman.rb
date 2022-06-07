class Hangman

  attr_accessor :secret_word, :guess_array, :guessed_characters_array, :correct_guess_array, :incorrect_guess_array, :available_moves

  def initialize
    self.guessed_characters_array = []
    self.correct_guess_array = []
    self.incorrect_guess_array = []
    self.available_moves = 12
  end

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
      raise StandardError, 'Please enter a single character' unless char.length == 1
      raise StandardError, 'Please enter an alphabet' unless char.to_i == 0
      raise StandardError, 'You have already guessed this character' if self.guessed_characters_array.include?(char.downcase)
      guessed_characters_array.push(char.downcase)
      char.downcase
    rescue StandardError => e
      puts e
      retry
    end
  end

  def play_game
    word_file = File.open('hangman_words.txt', 'r')
    self.secret_word = select_secret_word(word_file)
    self.guess_array = create_underscore_array(secret_word.length)
    puts secret_word.to_s

    until guess_array == secret_word || available_moves == 0

      # system('clear')
      puts incorrect_guess_array.to_s unless incorrect_guess_array.empty?
      puts
      puts guess_array.join(' ')
      puts
      puts "Available moves: #{available_moves}"
      puts

      current_char = get_char
      include_char = false

      secret_word.each_with_index do |char, index|
        if current_char == char
          guess_array[index] = current_char
          correct_guess_array.push(current_char)
          include_char = true
        end
      end

      if include_char == false
        incorrect_guess_array.push(current_char) 
        self.available_moves -= 1
      end
    end
    # puts
    # puts guess_array.join(' ')
  end
end

Hangman.new.play_game