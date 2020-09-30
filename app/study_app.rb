require "tty-prompt"

class StudyApp
    attr_reader :user
    attr_accessor :new_flashcard, :user_flashcards

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


    def main_menu
        puts "Make selection: study, collection or quit."
        input = gets.chomp.downcase
        if input == "study"
            # study_flashcards(Flashcard)
            view_flashcards(random_flashcard(Flashcard))
            new_card_or_save
        elsif input == 'collection'
            access_collection
        elsif input == 'quit'
            quit
        else
           main_menu
        # prompt = TTY::Prompt.new
        # prompt.select("What would you like to do?", %w(study-all, study-your-collection, login))
            #if study-all is selected @user.study_all
        end
    end

    # def study_flashcards(collection)
    #     view_flashcards(collection, random_flashcard)
    #     new_card_or_save
    # end

    def access_collection
        # puts "Type 'view' to show random card or 'create' to make a new card."
        # if UserFlashcard.all = []
        #     puts "Sorry, no cards saved in collection."
        # else
        @user_flashcards = UserFlashcard.all.where("user_id = ?", @user.id)
        # binding.pry
        view_flashcards(@user_flashcards, sample_from_collection)
        # end
    end

    def sample_from_collection(collection)
        user_flashcard_ids = collection.map {|fc| fc.flashcard_id}.sample
        #take in @user_flashcards and get back a sample
    end

    def view_flashcards(selector)
        puts "Translate this to english:"
        sleep(1)
        @new_flashcard = selector
        puts "#{@new_flashcard.sword}"
        puts "Type your translation to flip the flashcard."
        input = gets.chomp 
        sleep(1)
        puts "."
        sleep(1)
        puts ".."
        sleep(1)
        if input == @new_flashcard.eword
            puts "...Correct!"
        elsif input == 'quit'
            quit
        else
            puts "...Sorry, the correct answer is #{@new_flashcard.eword}."
        end 
    end


    def random_flashcard(collection)
        rand_id = rand(collection.count) + 1
        rand_record = collection.find(rand_id)
      end

    def new_card_or_save
        puts "Type 'new card' for another card, 'save' to add to collection, or 'menu'."
        input= gets.chomp.downcase 
            if input == 'new card'
                view_flashcards(random_flashcard(Flashcard))
                new_card_or_save
            elsif input == 'save'
                UserFlashcard.create(user_id: @user.id, flashcard_id: @new_flashcard.id)
                puts "Card saved to #{@user.username.capitalize}'s collection!"
                view_flashcards(random_flashcard(Flashcard))
                new_card_or_save
                #maybe make into another helper method to use when user creates own card
            elsif input == 'menu'
                main_menu 
            else new_card_or_save
        end
    end

    def quit
        puts "See you later!"
    end

end