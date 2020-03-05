require "pry"

# Used in finding the database username and password and making sure it matches up with inputted values
def validate_credentials(username:, password:)
    User.all.find {|user| user.username == username && user.password == password}
end

# Login Screen / Section
def login 
    valid_login = false
    while !valid_login do
        prompt = TTY::Prompt.new 
        
        response = prompt.select("What would you like to do?", ["Login", "Create a New User"])

        system("clear")
        
        # Checking which option was selected and proceed accordingly
        if response == "Login"
            puts "What is the username?"
            username = gets.chomp

            system("clear")

            password = prompt.mask("What is the password?")

            system("clear")

            # check if login is valid, if it's valid it'll return the db/class instance, otherwise it'll return nil
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
                password1 = prompt.mask("What is the password?")

                system("clear")

                password2 = prompt.mask("Validate the password please.")

                system("clear")

                password_validation = password1 == password2

                if !password_validation
                    puts "Passwords do not match. Try again."
                end
            end

            # Create user as instance and as db record
            logged_in_user = User.create(username: username, password: password2, high_score: 0)

            valid_login = true
        end
    end

    logged_in_user
end