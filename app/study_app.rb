require "tty-prompt"


class StudyApp
    attr_reader :user
    attr_accessor :new_flashcard

    def run
        welcome
        login
        choose_action
    end

    def welcome
        puts "Let's study!"
    end

    def login
        puts "Enter username to sign-up or log-in!"
        input = gets.chomp.downcase
        @user = User.find_or_create_by(username: input)
        puts "Welcome, #{@user.username.capitalize}"
    end

    def random_flashcard
        rand_id = rand(Flashcard.count) + 1
        rand_record = Flashcard.find(rand_id)
         #gets random flashcard, show question
      end

    def new_card_or_save
        puts "Type 'new card' for another card or 'save' to add to collection."
        input= gets.chomp.downcase 
            if input == 'new card'
                study_flashcards
            elsif input == 'save'
                UserFlashcard.create(user_id: @user.id, flashcard_id: @new_flashcard.id)
                # puts "#{UserFlashcard.where('user_id = ?', @user.id)}"
            else new_card_or_save
        end
    end
    
    def study_flashcards
        # puts "#{@user.username}"
        @new_flashcard = random_flashcard
        puts "#{@new_flashcard.question}"
        # random_card = Flashcard.question
        puts "Type any key to flip the flashcard."
        gets.chomp 
        puts "#{@new_flashcard.answer}"
        #gets user input and show answer
        new_card_or_save
        #add this flashcard to userflashcard or repeat
      end

    def choose_action
        puts "Make selection"
        input = gets.chomp.downcase
        if input == "study"
            study_flashcards
        # elsif input == "collection"
        #     @user.study_userflashcards
        else
            choose_action
        # prompt = TTY::Prompt.new
        # prompt.select("What would you like to do?", %w(study-all, study-your-collection, login))
            #if study-all is selected @user.study_all
        end
    end

end