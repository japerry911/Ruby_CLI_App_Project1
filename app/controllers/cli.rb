class CLI
    attr_reader :user
    attr_accessor :board, :score, :guesses, :game_word

    def initialize(user)
        @user = user
        @score = 100
        @board = []
        @guesses = []
    end

    def game
        start_game_banner

        topic = topic_selection
        self.game_word = select_word(topic)
        create_default_game_board(game_word)
        hangman_art_use = hangman_art
        print_hangman_art(hangman_art_use[0])

        game_over = false
        win = false 
        number_of_guesses = 0

        play_round_guess
        """while !game_over do
            correct_status = play_round_guess

            if !correct_status
                number_of_guesses += 1
            end

            win = check_if_finished

            if win
                break
            end
        end

        if win
            puts 'you win'
        else
            puts 'you lose'
        end"""
    end

    def play_round_guess
        binding.pry
        while true 
            puts "Which letter would you like to guess?"
            guess = gets.chomp

            valid_number = valid_letter_check(guess)
            
            case valid_number 
            when -1
                puts "Input was blank, try again, no guess penalty."
            when 0
                puts "Input has already been used in a guess, try again, no guess penalty."
            when 1
                round_result = check_guess(guess)
            end

            puts "Letter already guessed or invalid guess, guess again."
        end 
    end

    def check_guess(guess)
        if guess.length > 1
            if game_word.downcase == guess.downcase
                board = game_word.split("")
                return 0
            else
                return 1
            end
        else
            result = (0...game_word.length).select {|index| game_word[index].downcase == guess.downcase}

            for i in result
                binding.pry
            end
        end
    end

    def valid_letter_check(guess)
        binding.pry
        if guesses.include?(guess)
            return 0
        elsif guess.length == 0
            return -1
        else
            guesses << guess
            return 1
        end
    end

    def create_default_game_board(game_word)
        counter = 0
        board = []

        while counter < game_word.length do 
            board << "_"
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

    def print_hangman_art(hangman_art)
        art_split = hangman_art.split("\n")
        
        counter = 0

        while counter < art_split.length do 
            puts art_split[counter]
            counter += 1
        end
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