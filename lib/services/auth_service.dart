import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../core/database/database_helper.dart';
import '../models_books/user.dart';

// Servicio de autenticación: registro e inicio de sesión contra SQLite.
class AuthService {
  AuthService._internal();
  static final AuthService instance = AuthService._internal();

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Hash SHA-256 de la contraseña (no se guarda en texto plano).
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  // Registra un usuario. Devuelve true si se creó, false si el correo ya existe.
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final db = await _dbHelper.database;
    final existing = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email.trim().toLowerCase()],
      limit: 1,
    );
    if (existing.isNotEmpty) return false;

    final user = User(
      name: name.trim(),
      email: email.trim().toLowerCase(),
      passwordHash: _hashPassword(password),
    );
    await db.insert('users', user.toMap());
    return true;
  }

  // Inicia sesión. Devuelve el User si las credenciales son válidas, null si no.
  Future<User?> login({
    required String identifier,
    required String password,
  }) async {
    final db = await _dbHelper.database;
    final id = identifier.trim().toLowerCase();
    final rows = await db.query(
      'users',
      where: 'LOWER(name) = ? OR email = ?',
      whereArgs: [id, id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    final user = User.fromMap(rows.first);
    if (user.passwordHash != _hashPassword(password)) return null;
    return user;
  }

  // Indica si ya existe un usuario con ese correo.
  Future<bool> emailExists(String email) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email.trim().toLowerCase()],
      limit: 1,
    );
    return rows.isNotEmpty;
  }
}