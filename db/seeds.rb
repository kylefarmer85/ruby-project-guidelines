User.destroy_all
Flashcard.destroy_all

kyle = User.create(username: "Kyle")
manzana = Flashcard.create(question: "manzana", answer: "apple")
kylecard = UserFlashcard.create(user_id: kyle.id, flashcard_id: manzana.id )

