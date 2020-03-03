require "rest-client"
require "JSON"

Word.destroy_all
Topic.destroy_all

# Create the Ocean Topic + Ocean Topic Words
ocean_topic = Topic.create(topic: "Ocean")

response = RestClient.get("https://api.datamuse.com/words?topics=ocean")
ocean_topic_array = JSON.parse(response.body).map {|element| element["word"]}

ocean_topic_array.each do |word|
    Word.create(word_text: word, topic_id: ocean_topic.id)
end

# Create the Dogs Topic + Dogs Topic Words
dogs_topic = Topic.create(topic: "Dogs")

response = RestClient.get("https://api.datamuse.com/words?topics=dogs")
dogs_topic_array = JSON.parse(response.body).map {|element| element["word"]}

dogs_topic_array.each do |word|
    Word.create(word_text: word, topic_id: dogs_topic.id)
end

# Create the Weather Topic + Weather Topic Words
weather_topic = Topic.create(topic: "Weather")

response = RestClient.get("https://api.datamuse.com/words?topics=weather")
weather_topic_array = JSON.parse(response.body).map {|element| element["word"]}

weather_topic_array.each do |word|
    Word.create(word_text: word, topic_id: weather_topic.id)
end

# Create Sports Topic + Soprts Topic Words
sports_topic = Topic.create(topic: "Sports")

response = RestClient.get("https://api.datamuse.com/words?topics=sports")
sports_topic_array = JSON.parse(response.body).map {|element| element["word"]}

sports_topic_array.each do |word|
    Word.create(word_text: word, topic_id: sports_topic.id)
end