import 'package:flutter/foundation.dart';

class Book {
  final String title;
  final String author;
  final String? category;  //el '?' vuelve los datos opcionales
  final DateTime? publishedDate;

  const Book({required this.title, required this.author, this.category, this.publishedDate});
}

const List<Book> _librosIniciales = [
  Book(title: 'Cien años de soledad', author: 'Gabriel García Márquez'),
  Book(title: 'Don Quijote de la Mancha', author: 'Miguel de Cervantes'),
  Book(title: 'La casa de los espíritus', author: 'Isabel Allende'),
  Book(title: 'Rayuela', author: 'Julio Cortázar'),
  Book(title: 'El amor en los tiempos del cólera', author: 'Gabriel García Márquez'),
  Book(title: 'Ficciones', author: 'Jorge Luis Borges'),
  Book(title: 'Pedro Páramo', author: 'Juan Rulfo'),
  Book(title: 'La ciudad y los perros', author: 'Mario Vargas Llosa'),
  Book(title: 'Sobre héroes y tumbas', author: 'Ernesto Sabato'),
  Book(title: 'El túnel', author: 'Ernesto Sabato'),
];

final ValueNotifier<List<Book>> books = ValueNotifier<List<Book>>( _librosIniciales);

void addLibro(Book book) {books.value = [...books.value, book];}

// Indica si ya existe un libro con el mismo título y autor
bool existeLibro(String title, String author) {
  final t = title.trim().toLowerCase();
  final a = author.trim().toLowerCase();
  return books.value.any(
    (book) => book.title.toLowerCase() == t && book.author.toLowerCase() == a);
}