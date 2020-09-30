class CreateFlashcards < ActiveRecord::Migration[6.0]

  def change
    create_table :flashcards do |t|
      t.string :question
      t.string :answer
    end
  end
end