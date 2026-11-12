import '../core/database/database_helper.dart';
import '../models_books/book.dart';
import 'dart:io';
import '../models_books/loan.dart';

// Servicio de libros: guarda y consulta los libros en SQLite.
class LibroService {
  LibroService._internal();
  static final LibroService instance = LibroService._internal();

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // CREATE: guarda un libro nuevo y actualiza la lista que ven las pantallas.
  Future<int> insertarLibro(Book libro) async {
    final db = await _dbHelper.database;
    final id = await db.insert('libros', libro.toMap());
    await cargarLibros();
    return id;
  }

  // GET: lee todos los libros guardados en la base de datos.
  Future<List<Book>> obtenerLibros() async {
    final db = await _dbHelper.database;
    final filas = await db.query('libros', orderBy: 'id');
    return filas.map(Book.fromMap).toList();
  }

  // UPDATE: reemplaza los datos del libro que tiene el mismo id.
  Future<void> actualizarLibro(Book libro) async {
    final db = await _dbHelper.database;

    // Se busca cómo era el libro antes del cambio, para saber si cambió la portada.
    final anterior = books.value.where((b) => b.id == libro.id).firstOrNull;

    // "where: 'id = ?'" indica QUÉ fila cambiar; el "?" se reemplaza por whereArgs.
    // Así solo se modifica este libro y no toda la tabla.
    await db.update(
      'libros',
      libro.toMap(),
      where: 'id = ?',
      whereArgs: [libro.id],
    );

    // Si se cambió la portada, la foto anterior ya no se usa: se borra del teléfono.
    if (anterior != null && anterior.imagen != libro.imagen) {
      await _borrarImagen(anterior.imagen);
    }

    // Los préstamos guardan una copia del libro. Se cambia esa copia por la
    // versión nueva para que "Mis préstamos" muestre el título actualizado.
    loans.value = [
      for (final prestamo in loans.value)
        prestamo.book.id == libro.id
            ? Loan(user: prestamo.user, book: libro, date: prestamo.date)
            : prestamo,
    ];

    await cargarLibros();
  }

  // DELETE: borra el libro de la base de datos y su portada del teléfono.
  Future<void> eliminarLibro(Book libro) async {
    final db = await _dbHelper.database;
    await db.delete('libros', where: 'id = ?', whereArgs: [libro.id]);
    await _borrarImagen(libro.imagen);
    await cargarLibros();
  }


  // Carga los libros de la base en la lista `books`.
  // Los libros de ejemplo ya no se guardan aquí, sino una sola vez al crear
  Future<void> cargarLibros() async {
    books.value = await obtenerLibros();
  }

  // Borra el archivo de una portada. Si no existe o falla, no detiene la app:
  // lo importante (el libro en la base de datos) ya se guardó o se borró.
  Future<void> _borrarImagen(String? ruta) async {
    if (ruta == null) return;
    try {
      final archivo = File(ruta);
      if (await archivo.exists()) {
        await archivo.delete();
      }
      } catch (_) {
    }
  }
}
