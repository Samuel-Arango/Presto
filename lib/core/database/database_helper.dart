import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Singleton que gestiona la base de datos SQLite local de la app.
class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static const _dbName = 'presto.db';
  static const _dbVersion = 3;

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
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
  Future<void> _onUpgrade(Database db, int versionAnterior, int versionNueva) async {
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
  }

  Future<void> close() async {
    final db = _db;
    if (db != null) {
      await db.close();
      _db = null;
    }
  }
}