import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  Future<Database> _openDataBase() async {
    final databasepath = await getDatabasesPath();
    final path = join(databasepath, 'presto_database.db');

    return openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute('''
      CREATE TABLE prestos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT
      )
    ''');
      },
      version: 1,
    );
  }
}
