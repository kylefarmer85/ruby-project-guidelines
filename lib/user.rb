class User < ActiveRecord::Base
  has_many :flashcards, through: :userflashcards
  has_many :userflashcards
end