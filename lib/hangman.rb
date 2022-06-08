# frozen_string_literal: true

class Hangman
  attr_accessor :secret_word, :guess_array, :guessed_characters_array, :incorrect_guess_array, :available_moves

  def initialize
    default_values
  end

  def default_values
    self.guessed_characters_array = []
    self.guess_array = []
    self.incorrect_guess_array = []
    self.available_moves = 12
  end

  def select_secret_word(file)
    words = []
    until file.eof?
      current_word = file.readline.strip
      words.push(current_word) if current_word.length >= 5 && current_word.length <= 12
    end
    words.sample.split('')
  end

  def create_underscore_array(length)
    underscore_array = []
    length.times do
      underscore_array.push('_')
    end
    underscore_array
  end

  def get_char
    print 'Enter a character: '
    char = gets.chomp
    raise StandardError, 'Please enter a single character' unless char.length == 1
    raise StandardError, 'Please enter an alphabet' unless char.to_i.zero?

    if guessed_characters_array.include?(char.downcase)
      raise StandardError,
            'You have already guessed this character'
    end

    guessed_characters_array.push(char.downcase)
    char.downcase
  rescue StandardError => e
    puts e
    retry
  end

  def winner?
    guess_array == secret_word
  end

  def play_game
    system('clear')
    word_file = File.open('hangman_words.txt', 'r')
    self.secret_word = select_secret_word(word_file)
    self.guess_array = create_underscore_array(secret_word.length)
    puts secret_word.join('')

    until guess_array == secret_word || available_moves.zero?

      # system('clear')
      puts "Incorrect characters guessed: #{incorrect_guess_array.join(' ')}" unless incorrect_guess_array.empty?
      puts
      puts guess_array.join(' ')
      puts
      puts "Available moves: #{available_moves}"
      puts

      current_char = get_char
      include_char = false

      secret_word.each_with_index do |char, index|
        next unless current_char == char

        guess_array[index] = current_char
        include_char = true
      end

      if include_char == false
        incorrect_guess_array.push(current_char)
        self.available_moves -= 1
      end
    end

    system('clear')
    if winner?
      puts "You won the game!\n"
    else
      puts "You ran out of moves :(\n"
    end
    puts "The secret word is #{secret_word.join('')}"

    exit unless retry_game?
    default_values
    play_game
  end

  def retry_game?
    print "\nWould you like to restart the game?(y/n) "
    true if gets.chomp.downcase == 'y'
  end
end

Hangman.new.play_game
