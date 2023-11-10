import 'package:provider/provider.dart';

import './database_helper.dart';
import './firestore_helper.dart';
import '../models/note.dart';
import '../providers/note_provider.dart';

class Sync{
  static final DatabaseHelper _sqlite = DatabaseHelper();
  static final FirestoreHelper _firestore = FirestoreHelper();

  static Future<void> importFromCloud(context) async{
    List<Note> notes = await _firestore.getAllNotesCloud();
    for(Note note in notes){
      await _sqlite.insertNote(note);
    }
    Provider.of<NotesProvider>(context,listen:false).refresh();
  }

  static Future<void> uploadToCloud(context) async{
    List<Note> notes = await _sqlite.getAllNotes();
    for(Note note in notes){
      await _firestore.insertNoteCloud(note);
    }
  }
}