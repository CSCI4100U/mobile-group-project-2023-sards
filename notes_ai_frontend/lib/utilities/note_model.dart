import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note.dart';

class NotesModel {
  static final NotesModel _notesModel = NotesModel._();

  NotesModel._();

  late Database db;

  factory NotesModel() {
    return _notesModel;
  }

  Future<void> initDB() async {
    db = await openDatabase(join(await getDatabasesPath(), 'notes.db'),
        onCreate: (database, version) async {
          await database.execute("""CREATE TABLE notes(
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          title VARCHAR(64) NOT NULL, 
          text TEXT NOT NULL
          )""");
        }, version: 1);
  }

  Future<List<Note>> getAllNotes() async {
    final List noteMaps = await db.query("notes");
    return noteMaps.map((e) => Note.fromMap(e)).toList();
  }

  Future<int> insertNote(Note note) async {
    return await db.insert("notes", note.toMap());
  }

  Future<int> deleteNote(int id) async {
    return await db.delete("notes", where: "id = ?", whereArgs: [id]);
  }

  Future<int> updateNote(Note note) async {
    Map<String, dynamic> values = note.toMap();
    // Should not update the primary key, only the other columns
    values.remove("id");
    final count = await db
        .update("notes", values, where: "id = ?", whereArgs: [note.id]);
    return count;
  }
}