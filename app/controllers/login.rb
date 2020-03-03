require "pry"

def validate_credentials(username:, password:)
    User.all.find {|user| user.username == username && user.password == password}
end