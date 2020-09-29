require "tty-prompt"


class StudyApp
    attr_reader :user

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

    def choose_action
        puts "Make selection"
        input = gets.chomp.downcase
        if input == "study"
            @user.study_flashcards
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