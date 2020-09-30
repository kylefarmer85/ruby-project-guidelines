require "tty-prompt"


class StudyApp
    attr_reader :user
    attr_accessor :new_flashcard

    def run
        welcome
        login
        main_menu 
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
      end

    def new_card_or_save
        puts "Type 'new card' for another card, 'save' to add to collection, or 'menu'."
        input= gets.chomp.downcase 
            if input == 'new card'
                study_flashcards
            elsif input == 'save'
                UserFlashcard.create(user_id: @user.id, flashcard_id: @new_flashcard.id)
                puts "Card saved to #{@user.username.capitalize}'s collection!"
                #maybe make into another helper method to use when user creates own card
            elsif input == 'menu'
                main_menu 
            else new_card_or_save
        end
    end
    
    def study_flashcards
        puts "Translate this to english:"
        sleep(1)
        @new_flashcard = random_flashcard
        puts "#{@new_flashcard.sword}"
        puts "Type your eword to flip the flashcard."
        input = gets.chomp 
        sleep(1)
        puts "."
        sleep(1)
        puts ".."
        sleep(1)
        if input == @new_flashcard.eword
            puts "...Correct!"
        new_card_or_save
        else
            puts "...Sorry, the eword is #{@new_flashcard.eword}."
        new_card_or_save
        end 
    end

    def main_menu
        puts "Make selection: study, quit."
        input = gets.chomp.downcase
        if input == "study"
            study_flashcards
        elsif input == "quit"
            puts "See you later!"
        else
           main_menu
        # prompt = TTY::Prompt.new
        # prompt.select("What would you like to do?", %w(study-all, study-your-collection, login))
            #if study-all is selected @user.study_all
        end
    end

end