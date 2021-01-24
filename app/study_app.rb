require "tty-prompt"
require 'uri'
require 'net/http'
require 'openssl'
require 'pry'
require 'JSON'
require 'colorize'
require 'colorized_string'

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
        # runs first
        pastel = Pastel.new
        font = TTY::Font.new(:doom)
        pid = fork{ exec 'afplay', "NFF-bravo.wav" }
        puts pastel.yellow(font.write("Ven Conmigo!"))
        sleep(1)
        puts "\n\nLet's study Spanish!".colorize(:light_blue)
    end

    def login
        #runs second
        puts "\n\nEnter username to sign-up or log-in!"
        input = gets.chomp.downcase
        @user = User.find_or_create_by(username: input)
        puts "\n\nWelcome, #{@user.username.capitalize}!"
    end

    def tty_prompt
        #runs last
        #allow user to choose starting action
        prompt = TTY::Prompt.new
       selection = prompt.select("Make a Selection:".colorize(:yellow)) do |menu|
            menu.choice "Study new flashcards"
            menu.choice 'Study / manage your collection'
            menu.choice 'Create new flashcards'
            menu.choice 'Translate'
            menu.choice 'Sign-out'
            menu.choice 'Quit'
        end

        if selection == "Study new flashcards"
            view_flashcards(random_flashcard(Flashcard))
            new_card_or_save
        elsif selection == 'Study / manage your collection'
            study_collection
        elsif selection == 'Create new flashcards'
            create_card
        elsif selection == 'Translate'
            get_translation
        elsif selection == 'Sign-out'
            system("clear")
            login
            main_menu
        elsif selection == 'Quit'
            quit 
        end
    end

    def main_menu
        # runs third
        system("clear")
        sleep(1)
        pastel = Pastel.new
        font = TTY::Font.new(:doom)
        puts pastel.blue(font.write("menu"))
        tty_prompt
    end

    def get_translation
        system("clear")
        # allow user to type word or phrase to translate
        puts "Enter an English word or phrase to get a translation.\n\n".colorize(:yellow)
        user_input = gets.chomp.downcase 
        puts "\n\n" 
        # use input to fetch data from google translate API
        url = URI("https://google-translate20.p.rapidapi.com/translate?sl=en&text=#{user_input}&tl=es")
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        request = Net::HTTP::Get.new(url)
        request["x-rapidapi-host"] = 'google-translate20.p.rapidapi.com'
        request["x-rapidapi-key"] = '807242452dmshf265a3ae985a240p1097aejsnfc00a6192549'
        response = http.request(request)
        response_hash = JSON.parse(response.body)
        # return translation
        puts "Translation:".colorize(:light_blue)
        translation = response_hash["data"]["translation"]
        puts translation 
        puts "\n\n"
        sleep(1)
        # allow user to choose next action
        prompt = TTY::Prompt.new
        selection = prompt.select("Please choose:".colorize(:yellow)) do |menu|
            menu.choice "Get another translation?"
            menu.choice "Save to your collection"
            menu.choice 'Main Menu'
            menu.choice 'Quit'
        end
  
        if selection == "Get another translation?"
            get_translation
        elsif selection == 'Save to your collection'
            @new_flashcard = Flashcard.create(eword: user_input, sword: translation)
            sleep(1)
            save_card
            main_menu 
        elsif selection == 'Main Menu'
            main_menu
        elsif selection == 'Quit'
            quit 
        end
        
    end

    def create_card
        #use input to create a flashcard for collection
        system("clear")
        sleep(1)
        puts "Create your own card and save to your collection!".colorize(:yellow)
        sleep(1)
        puts "\n\nFirst, enter the Spanish word for your new card.\n\n"
        sword = gets.chomp
        sleep(1)
        puts "\n\nEnter the English translation.\n\n"
        eword = gets.chomp
        puts "\n\n"
        @new_flashcard = Flashcard.create(eword: eword, sword: sword)
        sleep(1)
        save_card

        # ask for next action
        prompt = TTY::Prompt.new
        selection = prompt.select("\n\nMake a Selection:".colorize(:yellow)) do |menu|
            menu.choice "Create another card"
            menu.choice 'Main Menu'
            menu.choice 'Quit'
        end
  
        if selection == "Create another card"
            create_card
        elsif selection == 'Main Menu'
            system('clear')
            main_menu
        elsif selection == "Quit"
            quit
        end
    end

    def study_collection
        system("clear")
        check_user_flashcards
        user_flashcard_ids = @user_flashcards.map {|fc| fc.flashcard_id}
        user_flashcards = user_flashcard_ids.map {|uf| Flashcard.find(uf)}
        swords = user_flashcards.map {|f| f.sword}
        prompt = TTY::Prompt.new
        selection = prompt.select("\n\nYour collection:\n\n", swords)
        new_flashcard = user_flashcards.find {|f| f.sword == selection}
        view_flashcards(new_flashcard)
        check_user_flashcards
        prompt = TTY::Prompt.new
        selection = prompt.select("\nMake a Selection:".colorize(:yellow)) do |menu|
            menu.choice "Back to Collection"
            menu.choice "Delete this card"
            menu.choice 'Main Menu'
            menu.choice 'Quit'
        end
  
        if selection == "Back to Collection"
            study_collection
        elsif selection == 'Delete this card'
            @user_flashcards.each do |uf|
                if uf.flashcard_id == new_flashcard.id
                    uf.destroy
                end
            end
            puts "Card deleted from #{@user.username.capitalize}'s collection!".colorize(:red)
            sleep(1)
            check_user_flashcards
            study_collection
        elsif selection == 'Main Menu'
            system('clear')
            main_menu
        elsif selection == "Quit"
            quit
        end     
    end

    def sample_from_collection(collection)
        check_user_flashcards
        user_flashcard_id = collection.map {|fc| fc.flashcard_id}.sample
        Flashcard.find(user_flashcard_id)
    end

    def save_card
      @user_flashcards = UserFlashcard.all.where("user_id = ?", @user.id)
      UserFlashcard.create(user_id: @user.id, flashcard_id: @new_flashcard.id)
      puts "Card saved to #{@user.username.capitalize}'s collection!".colorize(:green)
      sleep(1)
    end

    def view_flashcards(selector)
        system("clear")
        sleep(1)
        puts "Translate this to English:\n\n".colorize(:yellow)
        sleep(1)
        @new_flashcard = selector
        puts "#{@new_flashcard.sword}"
        sleep(1)
        puts "\n\nType your translation to see the answer.\n\n"
        input = gets.chomp 
        sleep(1)
        if input == @new_flashcard.eword
            pid = fork{ exec 'afplay', "NFF-success.wav" }
            puts "...Correct!\n\n".colorize(:light_blue)
            sleep(1)
        else
            pid = fork{ exec 'afplay', "NFF-usb-yes.wav" }
            puts "...Sorry, the correct answer is #{@new_flashcard.eword}.\n\n".colorize(:red)
            sleep(1)
        end 
    end


    def random_flashcard(collection)
        rand_id = rand(collection.count) + 1
        rand_record = collection.find(rand_id)
      end

    def new_card_or_save
        prompt = TTY::Prompt.new
        selection = prompt.select("Please choose:".colorize(:yellow)) do |menu|
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
            puts "Card saved to #{@user.username.capitalize}'s collection!\n\n".colorize(:green)
            sleep (1)
            view_flashcards(random_flashcard(Flashcard))
            new_card_or_save
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
            pid = fork{ exec 'afplay', "NFF-usb-yes.wav" }
            puts "\n\nSorry, no cards saved in collection.".colorize(:color => :white, :background => :red)
            main_menu
        end
    end

    def quit
       system("clear")
       sleep(1)
       pastel = Pastel.new
       font = TTY::Font.new(:doom)
       puts pastel.yellow(font.write("Adios!"))
       sleep(2)
       system("clear")
       exit!
    end

end