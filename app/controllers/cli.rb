# CLI Class - Command-line Class - Handles the whole game instance
class CLI
    # Macros for some instance variables that are used
    attr_reader :user
    attr_accessor :board, :score, :guesses, :game_word, :number_of_guesses

    # Initialize user instance variable, and set score to highest possible score of 60, and reset board
    def initialize(user)
        @user = user
        @score = 60
        @board = []
    end

    # The actual CLI Instance
    # Can access game and high scores from here
    def cli_instance
        # Loading Screen
        start_loading

        prompt = TTY::Prompt.new 

        # Loop through having the main banner & menu until they exit game
        while true do 
            main_banner

            response = prompt.select("Which would you like to do:", ["Play Game", "Check Highscore", "Exit"])

            puts

            if response == "Play Game"
                game
            elsif response == "Check Highscore"
                high_score_record = User.get_high_score
                
                puts "#{high_score_record.username} earned a high score of #{high_score_record.high_score}!"
                puts
                prompt.keypress("Press Enter or Space to continue.", keys: [:space, :return])
            else
                puts "Exiting Game. Goodbye!" 
                puts
                break
            end
        end
    end

    # Full game of Hangman (selected if they select 'Play Game')
    def game
        system("clear")

        # Set game up with selecting topic, game_word, and reseting the board to have the empty letters
        topic = topic_selection
        self.game_word = select_word(topic)
        reset_game(game_word)
        hangman_art_use = hangman_art

        # Set win to false and number_of_guesses to 0
        win = false 
        self.number_of_guesses = 0

        # While loop through the actual game of hangman
        while true do
            system("clear")

            play_round_guess(hangman_art_use)

            if self.number_of_guesses == 6
                # Game lost
                break
            elsif !self.board.index("_")
                # Game won
                win = true 
                break
            end
        end

        # Reveal the guessing game word
        puts
        puts "Game Word: #{self.game_word}"
        puts

        # Calculate final total score (1 incorrect guess equals minus 10 points from 60)
        total_score = self.score - (self.number_of_guesses * 10)

        # Display You Win or You Lose based off if they win or lose
        # Utilize the TTY::Font ascii art creation gem
        if win
            puts TTY::Font.new(:doom).write("You  Win!")
            puts "Total Score - #{total_score} pts"
        else
            puts TTY::Font.new(:doom).write("You  Lose!")
            puts "Total Score - #{total_score} pts"
        end

        # Update 'user' instance variable high score if it needs to be updated
        # Update also occurs in users table 
        if self.user.high_score < total_score
            self.user.update({:high_score => total_score})
        end

        prompt = TTY::Prompt.new 

        prompt.keypress("Press Enter or Space to continue.", keys: [:space, :return])
    end

    # Game logic. User is making their guess(es)
    def play_round_guess(hangman_art_use)
        system("clear")

        prompt = TTY::Prompt.new

        puts "Current game board:"
        print_game_board(hangman_art_use[self.number_of_guesses])

        # Letter/character guess
        puts "Which letter would you like to guess?"
        puts
        guess = gets.chomp
            
        # Use valid_letter_check function to check validity of letter
        case valid_letter_check(guess) 
        # -2 = Invalid option - character is not equal to A-Za-z letter
        when -2
            puts "Input is not a valid letter A-Z or a-z. Please try again."
            prompt.keypress("Press Enter or Space to continue.", keys: [:space, :return])
            play_round_guess(hangman_art_use)
        # -1 = blank input
        when -1
            puts "Input was blank, try again, no guess penalty."
            prompt.keypress("Press Enter or Space to continue.", keys: [:space, :return])
            play_round_guess(hangman_art_use)
        # 0 = already guessed letter
        when 0
            puts "Input has already been used in a guess, try again, no guess penalty."
            prompt.keypress("Press Enter or Space to continue.", keys: [:space, :return])
            play_round_guess(hangman_art_use)
        # 1 = valid guess || Check to see if letter is in game_word or if guess is equal to game_word
        when 1
            # returns 0 if it's a correct guess, otherwise return 1
            round_result = check_guess(guess)
            self.number_of_guesses += round_result 

            puts

            if round_result == 0
                puts "Nice guess - #{guess}!"
            else
                puts "Wrong guess - #{guess}! Your number of guesses is now: #{self.number_of_guesses}."
            end
            
            puts

            prompt.keypress("Press Enter or Space to see updated board:", keys: [:space, :return])
        end
    end

    # Fills in the game board with the letter(s) guessed
    def check_guess(guess)
        if guess.length > 1
            if self.game_word.downcase == guess.downcase
                self.board = game_word.split("")
                return 0
            else
                return 1
            end
        else
            result = (0...self.game_word.length).select {|index| self.game_word[index].downcase == guess.downcase}

            if result.length == 0
                return 1
            else
                for i in result
                    self.board[i] = guess
                end

                return 0
            end
        end
    end

    # Checks whether the input letter is valid
    def valid_letter_check(guess)
        if self.guesses.include?(guess)
            # Return 0, meaning that the guess has already been guessed
            return 0
        elsif guess.length == 0
            # Return -1, meaning that the guess is blank
            return -1
        elsif guess.match(/[A-Za-z]/) == nil
            # Return -2, meaning that the guess is an invalid letter A-Z a-z
            return -2
        else
            # Return 1, meaning that guess is valid / add guess to the guesses array.
            self.guesses << guess
            return 1
        end
    end


    # Initial state of the game board at the start of the game
    def reset_game(game_word)
        counter = 0
        self.board = []

        while counter < game_word.length do 
            self.board << "_"
            counter += 1
        end

        self.guesses = []
    end

    #  Random word is chosen from the topic that the user selected
    def select_word(topic)
        word_list = Word.where("topic_id = ?", topic.id)
        random_index = Random.rand(word_list.length)
        word_list[random_index].word_text
    end

    # User selects a topic from available options
    def topic_selection 
        prompt = TTY::Prompt.new 

        response = prompt.select("Which word would you like to play?", ["Ocean", "Dogs", "Weather", "Sports"])

        return Topic.where("topic = '#{response}'")[0]
    end

    # Fake progress bar and displays game header
    def start_loading
        system("clear")

        # puts "========================================".colorize(:red)
        puts "Game is starting..."
        sleep(2)
        0.step(100, 20) do |i|
            printf("\rProgress: [%-20s]", "=" * (i/5))
            sleep(0.5)
          end
    end

    # Prints out the game board
    def print_game_board(hangman_art)
        art_split = hangman_art.split("\n")
        
        counter = 0

        while counter < art_split.length do 
            puts art_split[counter]
            counter += 1
        end

        puts
        puts self.board.join(" ")
        puts
        puts "Guessed Letters: #{self.guesses.join(" ")}"
        puts
    end

    def main_banner
        system("clear")

        puts "==============================================================".colorize(:red)
        puts ""
        puts "Welcome to the Ruby Hangman CLI Application!"
        puts ""
        puts "==============================================================".colorize(:red)
    end

    # Displays the current state of the game board
    def hangman_art
        ['''
        +---+
        |   |
            |
            |
            |
            |
        =========''', '''
        +---+
        |   |
        O   |
            |
            |
            |
        =========''', '''
        +---+
        |   |
        O   |
        |   |
            |
            |
        =========''', '''
        +---+
        |   |
        O   |
       /|   |
            |
            |
        =========''', '''
        +---+
        |   |
        O   |
       /|\  |
            |
            |
        =========''', '''
        +---+
        |   |
        O   |
       /|\  |
       /    |
            |
        =========''', '''
        +---+
        |   |
        O   |
       /|\  |
       / \  |
            |
        =========''']
    end
end