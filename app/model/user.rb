class User < ActiveRecord::Base
  has_many :flashcards, through: :userflashcards
  has_many :userflashcards

  def random_card
    puts "random card"
     #gets random flashcard, show question
  end

  def study_flashcards
    puts "#{self.username}"
    random_card
    #gets user input and show answer
    #add this flashcard to userflashcard or repeat
    # flashcard.rand
    # puts "#{flashcard.question}"
  end

end