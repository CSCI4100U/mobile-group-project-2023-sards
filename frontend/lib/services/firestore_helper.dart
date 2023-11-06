import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanjou/models/note.dart';


class FirestoreHelper{
  final notesCollection = FirebaseFirestore.instance.collection('notes');

  Future<List<Note>> getAllNotesCloud() async {
    final QuerySnapshot snapshot = await notesCollection.get();
    return snapshot.docs
        .map((doc) => Note.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> insertNoteCloud(Note note) async {
    return notesCollection
        .add(note.toMap())
        .then((value) => print("Note Added $value"))
        .catchError((error) => print("Failed to add note: $error"));
  }

  Future<void> deleteNoteCloud(String referenceId) async {
    // String toDelete = notesCollection.doc(note.reference.id).toString();
    // print(toDelete);

    return notesCollection
        .doc(referenceId)
        .delete()
        .then((value) => print("Note Deleted "))
        .catchError((error) => print("Failed to delete note: $error"));
  }

  Future updateNoteCloud(String referenceId, Note note) async {
    return notesCollection
        .doc(referenceId)
        .update(note.toMap())
        .then((value) => print("Note Updated"))
        .catchError((error) => print("Failed to update note: $error"));
  }
}