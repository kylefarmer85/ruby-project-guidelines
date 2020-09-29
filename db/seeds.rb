User.destroy_all
Flashcard.destroy_all

kyle = User.create(username: "Kyle")
molly = User.create(username: "Molly")
justin = User.create(username: "Justin")

manzana = Flashcard.create(question: "manzana", answer: "apple")
hola = Flashcard.create(question: "hola", answer: "hello")


# card1 = UserFlashcard.create(user_id: kyle.id, flashcard_id: manzana.id )

