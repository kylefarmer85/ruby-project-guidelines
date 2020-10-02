Ven Conmigo!

Overview

Practice and test your knowledge of the Spanish language using a fun CLI app built with Ruby.
Has a built in dictionary of 25,000 "flashcards" to quiz yourself with.
User is able to create / delete their own Spanish word flashcards within their user collection. 
User can also create flashcards with words and phrases using the built-in Google Translate API and save them to their collection.

** Spanish/English database created by Manuel Gutierrez - github.com/xr09/shakespeare **

To Install:
Download or clone the repository and open it with a code editor. 
Open the terminal and start the app by entering: 
ruby bin/run.rb

* Using the CLI app:

1. Welcome User / Login
    -prompts user to login with username; if not found, the user is automatically created and saved to the database.

2. Main Menu - Use a selector to make a choice:

  A. Study new flashcards
       -A random Spanish word is picked from a dictionary.
       -User enters the english translation of the word.
       -User recieves notification if the attempt was right or wrong.
       -User has options to get another card, save the current card to the user collection, return to the main menu or quit the app.
          
  B. Study / manage collection
       -User's saved "cards" in their collection are displayed.
       -User selects an indivdual card to study.
       -User then chooses to return to collection, DELETE the card from their collection, return to main menu or quit the app.
       -If no cards are saved the message "Sorry, no cards saved in collection." will be displayed.

  C. Create new flashcards
       -User is prompted to enter their own spanish word and the english translation.
       -Card is saved to user's collection.
       -User may create another card, return to the main menu or quit.

  D. Translate - connected to Google Translate API
       -User is prompted to enter an English word or phrase.
       -The Spanish translation is returned from Google Translate.
       -User selects to get another translation, save the new words to a flashcard in the user's collection, return to the main menu or quit the app.

  E. Quit
       -User is signed out and app terminates.

* Contributing
  If you see an opportunity for improvement and can make the change yourself go ahead and use a typical git workflow to make it happen:
   -Fork this curriculum repository
   -Make the change on your fork, with descriptive commits in the standard format
   -Open a Pull Request against this repo

  Thank you!
