import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../models_books/book.dart';

// Singleton que gestiona la base de datos SQLite local de la app.
class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  // Nombre del archivo de la base de datos dentro del teléfono.
  static const _dbName = 'presto.db';
  // Versión de la base: sube cuando cambian las tablas (ver _onUpgrade).
  static const _dbVersion = 3;

  // Conexión a la base de datos. Es null hasta la primera vez que se usa.
  Database? _db;

  // Entrega la conexión. Si todavía no está abierta, la abre; así se abre una sola vez.
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  // Abre la base: busca la carpeta de bases de datos del teléfono, arma la ruta
  // de presto.db y llama a openDatabase (de sqflite).
  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    // onCreate se ejecuta la primera vez; onUpgrade, cuando sube la versión.
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Se ejecuta solo la primera vez, cuando el archivo de la base todavía no existe:
  // crea la tabla de usuarios y la de libros.
  Future<void> _onCreate(Database db, int version) async {
    // Tabla de usuarios: el correo es único y la contraseña se guarda cifrada.
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');
    await _crearTablaLibros(db);
  }

  // Si la base ya existía, la actualiza sin borrar los datos guardados.
  Future<void> _onUpgrade(
    Database db,
    int versionAnterior,
    int versionNueva,
  ) async {
    if (versionAnterior < 2) {
      // Versión 1: no tenía libros. La tabla nueva ya incluye la columna imagen.
      await _crearTablaLibros(db);
    } else if (versionAnterior < 3) {
      // Versión 2: ya tenía libros, solo falta la columna de la portada.
      await db.execute('ALTER TABLE libros ADD COLUMN imagen TEXT');
    }
  }

  // Tabla donde se guardan los libros del catálogo.
  Future<void> _crearTablaLibros(Database db) async {
    await db.execute('''
      CREATE TABLE libros (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        autor TEXT NOT NULL,
        categoria TEXT,
        fecha_publicacion TEXT,
        imagen TEXT
      )
    ''');

    // Guarda los libros de ejemplo UNA sola vez, justo al crear la tabla.
    // Si el usuario los elimina después, ya no vuelven a aparecer.
    for (final libro in librosIniciales) {
      await db.insert('libros', libro.toMap());
    }
  }

  // Cierra la conexión con la base de datos.
  Future<void> close() async {
    final db = _db;
    if (db != null) {
      await db.close();
      _db = null;
    }
  }
}
