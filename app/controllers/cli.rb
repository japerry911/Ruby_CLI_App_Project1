class CLI
    attr_reader :user
    attr_accessor :board, :score, :guesses, :game_word, :number_of_guesses

    def initialize(user)
        @user = user
        @score = 60
        @board = []
        @guesses = []
    end

    def game
        start_game_banner

        topic = topic_selection
        self.game_word = select_word(topic)
        create_default_game_board(game_word)
        hangman_art_use = hangman_art

        game_over = false
        win = false 
        self.number_of_guesses = 0

        while !game_over do
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

        if win
            puts 'you win'
            puts board.join(" ")
        else
            puts 'you lose'
        end
    end

    def play_round_guess(hangman_art_use)
        puts "Current game board:"
        print_game_board(hangman_art_use[number_of_guesses])

        puts "Which letter would you like to guess?"
        guess = gets.chomp
            
        case valid_letter_check(guess) 
        when -1
            puts "Input was blank, try again, no guess penalty."
            play_round_guess(hangman_art_use)
        when 0
            puts "Input has already been used in a guess, try again, no guess penalty."
            play_round_guess(hangman_art_use)
        when 1
            round_result = check_guess(guess)
            self.number_of_guesses += round_result 

            if round_result == 0
                puts "Nice guess!"
                puts
            else
                puts "Wrong guess! Your numnber of guesses is now: #{number_of_guesses}."
            end
        end
    end

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

    def valid_letter_check(guess)
        if self.guesses.include?(guess)
            # Return 0, meaning that the guess has already been guessed
            return 0
        elsif guess.length == 0
            # Return -1, meaning that the guess is blank
            return -1
        else
            # Return 1, meaning that guess is valid / add guess to the guesses array.
            self.guesses << guess
            return 1
        end
    end

    def create_default_game_board(game_word)
        counter = 0
        self.board = []

        while counter < game_word.length do 
            self.board << "_"
            counter += 1
        end
    end

    def select_word(topic)
        word_list = Word.where("topic_id = ?", topic.id)
        random_index = Random.rand(word_list.length)
        word_list[random_index].word_text
    end

    def topic_selection 
        puts "Which word topic would you like to play: 1 Ocean, 2 Dogs, 3 Weather, or 4 Sports?"
        topic_number = gets.chomp

        case topic_number
        when "1"
            return Topic.where("topic = 'Ocean'")[0]
        when "2"
            return Topic.where("topic = 'Dogs'")[0]
        when "3"
            return Topic.where("topic = 'Weather'")[0]
        when "4"
            return Topic.where("topic = 'Sports'")[0]
        else 
            "Invalid command, try again"
            topic_selection
        end 
    end

    def start_game_banner
        # puts "========================================".colorize(:red)
        puts "Game is starting..."
        sleep(2)
        0.step(100, 20) do |i|
            printf("\rProgress: [%-20s]", "=" * (i/5))
            sleep(0.5)
          end
        puts ""
        puts ""
        puts "========================================".colorize(:red)
        puts ""
        puts "Welcome to the Ruby Hangman CLI Application!"
        puts ""
        puts "========================================".colorize(:red)
        spinner = Enumerator.new do |e|
            loop do
              e.yield '|'
              e.yield '/'
              e.yield '-'
              e.yield '\\'
            end
          end
    end

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
    end

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