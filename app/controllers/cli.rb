class CLI
    attr_reader :user
    attr_accessor :board, :score

    def initialize(user)
        @user = user
        @score = 100
        @board = []
    end

    def game
        start_game_banner

        topic = topic_selection
        game_word = select_word(topic)
        create_default_game_board(game_word)
        hangman_art_use = hangman_art
        print_hangman_art(hangman_art_use[0])
        binding.pry
        """game_over = false
        win = false 
        number_of_guesses = 0

        while !game_over do
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

    def create_default_game_board(game_word)
        counter = 0

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