import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:kanjou/models/note.dart';

class DatabaseHelper {
  Database? db;

  Future<void> init() async {
    String path = await getDatabasesPath();
    String dbPath = join(path, 'notes.db');

    db = await openDatabase(dbPath, version: 2, onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE notes(
            id TEXT PRIMARY KEY NOT NULL,
            title TEXT NOT NULL,
            text TEXT NOT NULL,
            date TEXT NOT NULL,
            tag TEXT NOT NULL
          )
        ''');
    });
  }

  Future<List<Note>> getAllNotes() async {
    final List<Map<String, dynamic>> maps = await db!.query('notes');
    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  Future<int> insertNote(Note note) async {
    return await db!.insert('notes', note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteNote(Note note) async {
    return await db!.delete('notes', where: 'id = ?', whereArgs: [note.id]);
  }

  Future<int> updateNote(Note note) async {
    return await db!
        .update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }
}
