
class Book:
    def __init__(self, title: str, author: str, is_available: bool = True):
       
        self.title = title
        self.author = author
        self.is_available = is_available

    def __str__(self):
       
        return f"'{self.title}' de {self.author} - {'Disponible' if self.is_available else 'Indisponible'}"

class Library:
    def __init__(self):
        
        self.books = []

    def add_book(self, title: str, author: str):
       
        book = Book(title, author)
        self.books.append(book)

    def list_books(self):
        
        return [str(book) for book in self.books]

    def lend_book(self, book_title: str, student):
        
        for book in self.books:
            if book.title == book_title and book.is_available:
                book.is_available = False
                return True
        return False

    def accept_return(self, book_title: str, student):
       
        for book in self.books:
            if book.title == book_title:
                book.is_available = True
                return True
        return False

    def search_books(self, query: str):
        
        found_books = []
        for book in self.books:
            if query.lower() in book.title.lower() or query.lower() in book.author.lower():
                found_books.append(str(book))
        return found_books

    def save_books(self, file_path: str):
        
        with open(file_path, 'w') as file:
            for book in self.books:
                file.write(f"{book.title},{book.author},{book.is_available}\n")
        print(f"Les livres ont été sauvegardés dans {file_path}.")

    def load_books(self, file_path: str):
       
        try:
            with open(file_path, 'r') as file:
                for line in file:
                    title, author, is_available = line.strip().split(',')
                    is_available = is_available == 'True'
                    self.add_book(title, author)
                    self.books[-1].is_available = is_available
            print(f"Les livres ont été chargés depuis {file_path}.")
        except FileNotFoundError:
            print(f"Erreur : Le fichier {file_path} n'a pas été trouvé.")