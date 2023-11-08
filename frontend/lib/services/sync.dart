import './database_helper.dart';
import './firestore_helper.dart';
import '../models/note.dart';

class Sync{
  static final DatabaseHelper _sqlite = DatabaseHelper();
  static final FirestoreHelper _firestore = FirestoreHelper();

  static Future<void> importFromCloud() async{
    List<Note> notes = await _firestore.getAllNotesCloud();
    for(Note note in notes){
      await _sqlite.insertNote(note);
    }
  }

  static Future<void> syncToCloud() async{
    List<Note> notes = await _sqlite.getAllNotes();
    for(Note note in notes){
      await _firestore.insertNoteCloud(note);
    }
  }
}