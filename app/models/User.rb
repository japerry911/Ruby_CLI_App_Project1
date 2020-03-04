class User < ActiveRecord::Base
    def self.get_high_score
        User.order("high_score DESC").first
    end
end