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
            view_flashcards(random_flashcard(Flashcard))
            new_card_or_save
        elsif input == 'collection'
            access_collection
        elsif input == 'quit'
            quit
        else
           main_menu
        end
    end

    def access_collection
        check_user_flashcards
        view_flashcards(sample_from_collection(@user_flashcards))
        new_card_or_delete
    end

    def sample_from_collection(collection)
        check_user_flashcards
        user_flashcard_id = collection.map {|fc| fc.flashcard_id}.sample
        Flashcard.find(user_flashcard_id)
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
        # elsif input == 'quit'
        #     quit
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

    def new_card_or_delete
        puts "Type 'new card' for another card, 'delete' to add to collection, or 'menu'."
        input= gets.chomp.downcase 
            if input == 'new card'
                view_flashcards(sample_from_collection(@user_flashcards))
                new_card_or_delete
            elsif input == 'delete'
                @user_flashcards.destroy_by(flashcard_id: @new_flashcard.id)
                puts "Card deleted from #{@user.username.capitalize}'s collection!"
                check_user_flashcards
                view_flashcards(sample_from_collection(@user_flashcards))
                new_card_or_delete
            else input == 'menu'
                main_menu  
        end
    end

    def check_user_flashcards
        @user_flashcards = UserFlashcard.all.where("user_id = ?", @user.id)
        if @user_flashcards == []
            puts "Sorry, no cards saved in collection."
            main_menu
        end
    end

    def quit
       puts "See you later!"
       sleep(2)
       exit!
    end

end