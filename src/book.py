
class Book:
    def __init__(self, title: str, author: str, is_available: bool = True):
       
        self.title = title
        self.author = author
        self.is_available = is_available

    def __str__(self):
        
        availability = "Disponible" if self.is_available else "Indisponible"
        return f"'{self.title}' de {self.author} - {availability}"