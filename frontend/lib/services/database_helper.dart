import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Future init() async {
    // set up the database
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'notes.db');

    var database =
        await openDatabase(dbPath, version: 1, onCreate: (db, version) {
      db.execute('''
        CREATE TABLE notes(
          id TEXT PRIMARY KEY NOT NULL,
          title TEXT NOT NULL,
          text TEXT NOT NULL,
          date TEXT NOT NULL
        )
      ''');
    });

    print("Database Created");
    return database;
  }
}
