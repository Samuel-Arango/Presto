import 'package:flutter/foundation.dart';

class Book {
  final int? id; // Lo asigna la base de datos al guardar el libro.
  final String title;
  final String author;
  final String? category;  //el '?' vuelve los datos opcionales
  final DateTime? publishedDate;

  const Book({this.id, required this.title, required this.author, this.category, this.publishedDate});

  // Convierte el libro en un Map para guardarlo en SQLite.
  Map<String, dynamic> toMap() => {
        'titulo': title,
        'autor': author,
        'categoria': category,
        'fecha_publicacion': publishedDate?.toIso8601String(),
      };

  // Crea un libro a partir de una fila leída de SQLite.
  factory Book.fromMap(Map<String, dynamic> map) => Book(
        id: map['id'] as int?,
        title: map['titulo'] as String,
        author: map['autor'] as String,
        category: map['categoria'] as String?,
        publishedDate: map['fecha_publicacion'] == null
            ? null
            : DateTime.parse(map['fecha_publicacion'] as String),
      );
}

// Libros de ejemplo: se guardan en la base de datos la primera vez que se abre la app.
const List<Book> librosIniciales = [
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

// Lista que ven las pantallas. Se llena desde SQLite al abrir la app (LibroService).
final ValueNotifier<List<Book>> books = ValueNotifier<List<Book>>(librosIniciales);

void addLibro(Book book) {books.value = [...books.value, book];}

// Indica si ya existe un libro con el mismo título y autor
bool existeLibro(String title, String author) {
  final t = title.trim().toLowerCase();
  final a = author.trim().toLowerCase();
  return books.value.any(
    (book) => book.title.toLowerCase() == t && book.author.toLowerCase() == a);
}