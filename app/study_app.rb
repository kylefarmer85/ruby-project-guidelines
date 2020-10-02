require "tty-prompt"
require 'uri'
require 'net/http'
require 'openssl'
require 'pry'
require 'JSON'

class StudyApp
    attr_reader :user
    attr_accessor :new_flashcard, :user_flashcards

    def run
        system("clear")
        welcome
        login
        main_menu 
    end

    def welcome
        pastel = Pastel.new
        font = TTY::Font.new(:doom)
        puts pastel.yellow(font.write("Spanish Buddy"))
        sleep(1)
        puts "\n\nLet's study!"
    end

    def login
        sleep(1)
        puts "\n\nEnter username to sign-up or log-in!"
        input = gets.chomp.downcase
        @user = User.find_or_create_by(username: input)
        puts "\n\nWelcome, #{@user.username.capitalize}!"
        sleep(1)
    end


    def main_menu
        prompt = TTY::Prompt.new
        selection = prompt.select("Make a Selection:") do |menu|
            menu.choice "Study new flashcards"
            menu.choice 'Study your collection'
            menu.choice 'Create new flashcards'
            menu.choice 'Translate'
            menu.choice 'Quit'
        end
  
        if selection == "Study new flashcards"
            view_flashcards(random_flashcard(Flashcard))
            new_card_or_save
        elsif selection == 'Study your collection'
            access_collection
        elsif selection == 'Create new flashcards'
            create_card
        elsif selection == 'Translate'
            get_translation
        elsif selection == 'Quit'
            quit 
        end
    end

    def get_translation
        puts "Enter english word to get translation."
        @user_input = gets.chomp.downcase  
        url = URI("https://google-translate20.p.rapidapi.com/translate?sl=en&text=#{@user_input}&tl=es")
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        request = Net::HTTP::Get.new(url)
        request["x-rapidapi-host"] = 'google-translate20.p.rapidapi.com'
        request["x-rapidapi-key"] = '807242452dmshf265a3ae985a240p1097aejsnfc00a6192549'
        response = http.request(request)
        response_hash = JSON.parse(response.body)
        puts response_hash["data"]["translation"]
        # pid = fork{ exec 'afplay', NFF-usb-yes.wav}
    end

    def access_collection
        check_user_flashcards
        view_flashcards(sample_from_collection(@user_flashcards))
        new_card_or_delete
    end

    def create_card
        puts "Create your own card and save to you collection!"
        sleep(1)
        puts "First, enter the spanish word for your new flashcard."
        sword = gets.chomp
        puts "Enter the english translation."
        eword = gets.chomp
        @new_flashcard = Flashcard.create(eword: eword, sword: sword)
        save_card
    end

    def sample_from_collection(collection)
        check_user_flashcards
        user_flashcard_id = collection.map {|fc| fc.flashcard_id}.sample
        Flashcard.find(user_flashcard_id)
    end

    def save_card
      @user_flashcards = UserFlashcard.all.where("user_id = ?", @user.id)
      UserFlashcard.create(user_id: @user.id, flashcard_id: @new_flashcard.id)
      puts "Card saved to #{@user.username.capitalize}'s collection!"
      main_menu
    end

    def view_flashcards(selector)
        system("clear")
        puts "Translate this to english:\n\n"
        sleep(1)
        @new_flashcard = selector
        puts "#{@new_flashcard.sword}"
        sleep(1)
        puts "\n\nType your translation to flip the flashcard.\n\n"
        input = gets.chomp 
        sleep(1)
        puts "."
        sleep(1)
        puts ".."
        sleep(1)
        if input == @new_flashcard.eword
            puts "...Correct!\n\n"
            sleep(1)
        else
            puts "...Sorry, the correct answer is #{@new_flashcard.eword}.\n\n"
            sleep(1)
        end 
    end


    def random_flashcard(collection)
        rand_id = rand(collection.count) + 1
        rand_record = collection.find(rand_id)
      end

    def new_card_or_save
        prompt = TTY::Prompt.new
        selection = prompt.select("Please choose:") do |menu|
            menu.choice 'Get another card'
            menu.choice 'Save card to Collection'
            menu.choice 'Main Menu'
            menu.choice 'Quit'
        end
  
        if selection == 'Get another card'
            view_flashcards(random_flashcard(Flashcard))
            new_card_or_save
        elsif selection == 'Save card to Collection'
            UserFlashcard.create(user_id: @user.id, flashcard_id: @new_flashcard.id)
            puts "Card saved to #{@user.username.capitalize}'s collection!\n\n"
            view_flashcards(random_flashcard(Flashcard))
            new_card_or_save
        elsif selection == 'Main Menu'
            system("clear")
            main_menu 
        elsif selection == 'Quit'
            quit
        end
    end

    def new_card_or_delete
        prompt = TTY::Prompt.new
        selection = prompt.select("Please choose:") do |menu|
            menu.choice 'Get another card'
            menu.choice 'Delete card from Collection'
            menu.choice 'Main Menu'
            menu.choice 'Quit'
        end
  
        if selection == 'Get another card'
            view_flashcards(sample_from_collection(@user_flashcards))
            new_card_or_delete
        elsif selection == 'Delete card from Collection'
            @user_flashcards.destroy_by(flashcard_id: @new_flashcard.id)
            system("clear")
            puts "Card deleted from #{@user.username.capitalize}'s collection!"
            sleep(1)
            check_user_flashcards
            view_flashcards(sample_from_collection(@user_flashcards))
            new_card_or_delete
        elsif selection == 'Main Menu'
            system("clear")
            main_menu 
        elsif selection == 'Quit'
            quit
        end
    end

    def check_user_flashcards
        @user_flashcards = UserFlashcard.all.where("user_id = ?", @user.id)
        if @user_flashcards == []
            system("clear")
            sleep(1)
            puts "Sorry, no cards saved in collection."
            sleep(1)
            main_menu
        end
    end

    def quit
       puts "See you later!"
       sleep(2)
       exit!
    end

end