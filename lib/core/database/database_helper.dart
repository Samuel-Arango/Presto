import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Singleton que gestiona la base de datos SQLite local de la app.
class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static const _dbName = 'presto.db';
  static const _dbVersion = 2;

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

  // Si la base ya existía (versión 1), agrega la tabla de libros sin borrar los usuarios.
  Future<void> _onUpgrade(Database db, int versionAnterior, int versionNueva) async {
    if (versionAnterior < 2) {
      await _crearTablaLibros(db);
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
        fecha_publicacion TEXT
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