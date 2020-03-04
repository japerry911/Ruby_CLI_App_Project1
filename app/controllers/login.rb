require "pry"

def validate_credentials(username:, password:)
    User.all.find {|user| user.username == username && user.password == password}
end

def login 
    valid_login = false
    while !valid_login do
        prompt = TTY::Prompt.new 
        
        response = prompt.select("What would you like to do?", ["Login", "Create a New User"])

        system("clear")
        
        if response == "Login"
            puts "What is the username?"
            username = gets.chomp

            system("clear")

            puts "What is the password?"
            password = gets.chomp 

            system("clear")

            valid_login = validate_credentials(username: username, password: password)
            
            if !valid_login 
                puts "---Invalid Credentials!---"
                next
            end

            logged_in_user = valid_login
        elsif response == "Create a New User"
            puts "What is the username?"
            username = gets.chomp

            system("clear")

            password_validation = false

            while !password_validation do 
                puts "What is the password?"
                password1 = gets.chomp

                system("clear")

                puts "Validate the password please."
                password2 = gets.chomp

                system("clear")

                password_validation = password1 == password2

                if !password_validation
                    puts "Passwords do not match. Try again."
                end
            end

            logged_in_user = User.create(username: username, password: password2, high_score: 0)

            valid_login = true
        end
    end

    logged_in_user
end