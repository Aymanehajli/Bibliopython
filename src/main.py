
from library import Library
from student import Student

def run_library_system():
    library = Library()
    library.load_books('books_data.txt')

    if not library.books:
        # Ajouter des livres par défaut si le fichier est vide
        library.add_book('1984', 'George Orwell')
        library.add_book('Brave New World', 'Aldous Huxley')
        library.add_book('Fahrenheit 451', 'Ray Bradbury')
        library.add_book('Animal Farm', 'George Orwell')

    student = Student("John Doe", max_borrow_limit=3)  # Limite d'emprunt de 3 livres

    while True:
        print("\n--- Menu ---")
        print("1. Voir tous les livres")
        print("2. Chercher un livre")
        print("3. Ajouter un nouveau livre")
        print("4. Emprunter un livre")
        print("5. Rendre un livre")
        print("6. Quitter")

        choice = input("Choisissez une option (1-6): ")

        if choice == '1':
            print("\nLivres dans la bibliothèque :")
            for book in library.list_books():
                print(book)
        elif choice == '4':
            book_title = input("Entrez le titre du livre que vous souhaitez emprunter : ")
            student.borrow_book(book_title, library)
        elif choice == '6':
            print("Merci d'avoir utilisé le système de gestion de bibliothèque !")
            library.save_books('books_data.txt')
            break

if __name__ == "__main__":
    run_library_system()