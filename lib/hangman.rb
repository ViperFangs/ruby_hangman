# frozen_string_literal: true

require 'yaml'

# class Hangman contains all methods to run the game Hangman
class Hangman

  def initialize
    default_values
  end

  def default_values
    self.guessed_characters_array = []
    self.guess_array = []
    self.incorrect_guess_array = []
    self.available_moves = 12
  end

  def start
    start_screen

    print "\nEnter your option: "
    user_input = gets.chomp

    case user_input
    when '1'
      initial_game_values
      play_game
    when '2'
      system('clear')
      begin
        start unless display_save_files
        print "\nEnter the file name you would like to load: "
        user_input = gets.chomp
        raise StandardError unless File.exist? "saves/#{user_input}.yml"

        load_game(user_input)
        play_game
      rescue StandardError
        puts "Please provide a valid filename\n"
        retry
      end
    else
      start
    end
  end

  private

  attr_accessor :secret_word, :guess_array, :guessed_characters_array, :incorrect_guess_array, :available_moves

  def start_screen
    system('clear')
    puts 'Hangman Game'
    puts "\nWould you like to start a new game or load a previous save?"
    puts 'Enter 1 to start a new game'
    puts 'Enter 2 to load a previous save'
  end

  def display_save_files
    save_files_array = Dir.children('saves')
    return false if save_files_array.empty?

    puts "\nSave Files\n\n"
    save_files_array.each do |file_name|
      file_name.slice! File.extname(file_name)
      puts "\t#{file_name}"
    end
  end

  def initial_game_values
    word_file = File.open('hangman_words.txt', 'r')
    self.secret_word = select_secret_word(word_file)
    self.guess_array = create_underscore_array(secret_word.length)
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
    print "\nGuess a character or enter \'save\' to save the game: "
    input = gets.chomp
    return input if input.downcase == 'save'
    raise StandardError, "Please enter an alphabet or enter \'save\' to save the game" unless input.to_i.zero?
    raise StandardError, "Please enter a single alphabet or enter \'save\' to save the game" unless input.length == 1
    raise StandardError, 'You have already guessed this character' if guessed_characters_array.include?(input.downcase)

    guessed_characters_array.push(input.downcase)
    input.downcase
  rescue StandardError => e
    puts e
    retry
  end

  def winner?
    guess_array == secret_word
  end

  def play_game
    until guess_array == secret_word || available_moves.zero?
      play_game_ui

      current_char = get_char
      if current_char == 'save'
        save_game
        next
      end
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
    end_game
  end

  def play_game_ui
    system('clear')
    puts "Incorrect characters guessed: #{incorrect_guess_array.join(' ')}" unless incorrect_guess_array.empty?
    puts
    puts guess_array.join(' ')
    puts
    puts "Available moves: #{available_moves}"
  end

  def end_game
    system('clear')
    if winner?
      puts "You won the game!\n"
    else
      puts "You ran out of moves :(\n"
    end
    puts "The secret word is #{secret_word.join('')}"

    exit unless retry_game?
    default_values
    start
  end

  def retry_game?
    print "\nWould you like to restart the game?(y/n) "
    true if gets.chomp.downcase == 'y'
  end

  def save_game
    print "\nEnter a name for the save file: "
    user_input = gets.chomp

    Dir.mkdir('saves') unless Dir.exist?('saves')
    filename = "saves/#{user_input}.yml"

    save_file = create_yaml

    File.open(filename, 'w') do |file|
      file.puts save_file
    end

    puts "\nYour file has been saved"
    exit unless continue_game?
  end

  def continue_game?
    print "\nWould you like to continue the game?(y/n) "
    true if gets.chomp.downcase == 'y'
  end

  def create_yaml
    YAML.dump({
                guess_array: guess_array,
                incorrect_guess_array: incorrect_guess_array,
                available_moves: available_moves,
                guessed_characters_array: guessed_characters_array,
                secret_word: secret_word
              })
  end

  def load_game(filename)
    filename = "saves/#{filename}.yml"
    load_game_file = YAML.load_file filename
    load_game_change_variables(load_game_file[:secret_word], load_game_file[:guess_array], load_game_file[:guessed_characters_array],
                               load_game_file[:incorrect_guess_array], load_game_file[:available_moves])
  end

  def load_game_change_variables(secret_word, guess_array, guessed_characters_array, incorrect_guess_array, available_moves)
    self.secret_word = secret_word
    self.guess_array = guess_array
    self.guessed_characters_array = guessed_characters_array
    self.incorrect_guess_array = incorrect_guess_array
    self.available_moves = available_moves
  end
end
