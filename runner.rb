require_relative "./config/environment"

valid_login = false
while !valid_login do
    puts "Would you like to 1 Login, or 2 Create a New User?"
    login_or_create = gets.chomp

    if login_or_create == "1"
        puts "What is the username?"
        username = gets.chomp

        puts "What is the password?"
        password = gets.chomp 

        valid_login = validate_credentials(username: username, password: password)
        
        if !valid_login 
            puts "---Invalid Credentials!---"
            next
        end

        logged_in_user = valid_login
    elsif login_or_create == "2"
        puts "What is the username?"
        username = gets.chomp

        password_validation = false

        while !password_validation do 
            puts "What is the password?"
            password1 = gets.chomp

            puts "Validate the password please."
            password2 = gets.chomp

            password_validation = password1 == password2

            if !password_validation
                puts "Passwords do not match. Try again."
            end
        end

        logged_in_user = User.create(username: username, password: password2, high_score: 0)

        valid_login = true
    end
end

binding.pry

# start game here use logged_in_user as input