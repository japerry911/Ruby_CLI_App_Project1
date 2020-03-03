class CreateWords < ActiveRecord::Migration[6.0]
  def change
    create_table :words do |t|
      t.string :word_text
      t.references :topic, foreign_key: true
    end
  end
end
