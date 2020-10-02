class Flashcard < ActiveRecord::Base
  has_many :users, through: :userflashcards
  has_many :userflashcards
end
