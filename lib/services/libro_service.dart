import '../core/database/database_helper.dart';
import '../models_books/book.dart';

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

  // Carga los libros de la base en la lista `books`.
  // Si la tabla está vacía (primera vez), guarda antes los libros de ejemplo.
  Future<void> cargarLibros() async {
    var libros = await obtenerLibros();
    if (libros.isEmpty) {
      final db = await _dbHelper.database;
      for (final libro in librosIniciales) {
        await db.insert('libros', libro.toMap());
      }
      libros = await obtenerLibros();
    }
    books.value = libros;
  }
}
