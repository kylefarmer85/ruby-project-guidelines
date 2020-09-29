class CreateUserFlashcards < ActiveRecord::Migration[6.0]
  def change
    create_table :user_flashcards do |t|
      t.integer :user_id
      t.integer :flashcard_id
    end
  end
end