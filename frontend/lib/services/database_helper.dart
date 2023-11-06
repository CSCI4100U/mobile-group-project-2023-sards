import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:kanjou/models/note.dart';

class DatabaseHelper {
  static Future<Database> _init() async {
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

  Future<List<Note>> getAllNotes() async {
    final db = await _init();
    final List<Map<String, dynamic>> maps = await db.query('notes');
    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  Future<int> insertNote(Note note) async {
    final db = await _init();
    return await db.insert('notes', note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteNote(Note note) async {
    final db = await _init();
    return await db.delete('notes', where: 'id = ?', whereArgs: [note.id]);
  }

  Future<int> updateNote(Note note) async {
    final db = await _init();
    return await db
        .update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }
}
