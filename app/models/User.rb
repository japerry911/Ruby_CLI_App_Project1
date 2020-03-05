class User < ActiveRecord::Base
    # Pull the high score from the users database
    def self.get_high_score
        User.order("high_score DESC").first
    end
end