import 'package:provider/provider.dart';

import 'package:kanjou/services/database_helper.dart';
import 'package:kanjou/services/firestore_helper.dart';
import 'package:kanjou/models/note.dart';
import 'package:kanjou/providers/note_provider.dart';

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
    List<Note> notes = Provider.of<NotesProvider>(context,listen:false).notes;
    for(Note note in notes){
      await _firestore.insertNoteCloud(note);
    }
  }
}