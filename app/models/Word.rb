# Each word has a topic, and topics have many words
class Word < ActiveRecord::Base
    belongs_to :topic
end