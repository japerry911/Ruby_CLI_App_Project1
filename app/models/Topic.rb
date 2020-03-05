# Topic has many words, and each word has a topic
class Topic < ActiveRecord::Base
    has_many :words
end