short description, install instructions, a contributors guide and a link to the license for your code

CLI Application Using Active Record

#Purpose
Browse and study flashcards; Create a customized flashcard collection

##Domain Model
User >- UserFlashcard --< Flashcard
The user will have many flashcards through user flashcard collection.

###Steps (written in order in the app file)
1. Welcome User 
  -prompt for username, create one if doesn't exist

2. Prompt User Actions- Use a selector to allow user to make choice
    a. Study all (from Flashcard database)
          random flashcard question is shown
          *user action*
          show flashcard answer
                option a. save to collection (then show another random card)
                option b. next card (another random card)
                option c. return to menu
    b. Access your collection (from UserFlashcard)
          random flashcard question from user flashcard collection
          *user action*
          show user flashcard answer
          a. study/pull random cards from collection
            -next card OR
            - delete from collection (then show another random card)
            -main menu
          b. create new card!
              -enter question
              -enter answer
    c. sign-out/exit (back to sign-in)
    **BONUS**
    d. Study by category
            option a. category1
            option b. category 2
            option c. cate
    e. search translation by word