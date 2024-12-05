
class Student:
    def __init__(self, name: str, max_borrow_limit: int = 3):
        
        self.name = name
        self.borrowed_books = []  
        self.max_borrow_limit = max_borrow_limit  

    def borrow_book(self, book_title: str, library):
        
        
        if len(self.borrowed_books) >= self.max_borrow_limit:
            print(f"{self.name}, vous avez atteint la limite d'emprunt ({self.max_borrow_limit} livres). Vous devez retourner un livre avant d'en emprunter un autre.")
            return False
        
       
        if library.lend_book(book_title, self):
            self.borrowed_books.append(book_title)
            print(f"{self.name} a emprunté '{book_title}'.")
            return True
        else:
            print(f"Le livre '{book_title}' est indisponible ou déjà emprunté.")
            return False

    def return_book(self, book_title: str, library):
        
        if book_title in self.borrowed_books:
            self.borrowed_books.remove(book_title)
            library.accept_return(book_title, self)
            print(f"{self.name} a retourné '{book_title}'.")
        else:
            print(f"{self.name}, vous n'avez pas emprunté ce livre.")