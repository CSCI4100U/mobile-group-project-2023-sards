

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanjou/models/note.dart';

class NotesModel {
  final notesCollection = FirebaseFirestore.instance.collection('notes');

  Future<void> insertNote(NoteSkeleton note) async {
    return notesCollection
        .add(note.toMap())
        .then((value) => print("Note Added $value"))
        .catchError((error) => print("Failed to add note: $error"));
  }

  Future<void> deleteNote(String referenceId) async {
    // String toDelete = notesCollection.doc(note.reference.id).toString();
    // print(toDelete);

    return notesCollection
        .doc(referenceId)
        .delete()
        .then((value) => print("Note Deleted "))
        .catchError((error) => print("Failed to delete note: $error"));
  }

  Future updateNote(String referenceId, NoteSkeleton note) async {
    return notesCollection
        .doc(referenceId)
        .update(note.toMap())
        .then((value) => print("Note Updated"))
        .catchError((error) => print("Failed to update note: $error"));
  }
}
