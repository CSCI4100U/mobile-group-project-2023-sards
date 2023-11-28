import 'package:kanjou/models/note.dart';
import 'package:kanjou/providers/note_provider.dart';

// Method to search for a note based on the title, text, or tag
// This method returns the list of notes sorted based on how close the title and text is to the query
List<Note> fuzzySearch(String query, NotesProvider notesProvider) {
  List<Note> notes = notesProvider.notes;
  List<Note> results = [];
  query = query.toLowerCase();

  for (int i = 0; i < notes.length; i++) {
    Note note = notes[i];
    if (note.title.toLowerCase().contains(query) ||
        note.text.toLowerCase().contains(query) ||
        note.tag != null && note.tag!.toLowerCase().contains(query)) {
      results.add(note);
    }
  }
  results.sort((a, b) {
    int aScore = 0;
    int bScore = 0;
    if (a.title.toLowerCase().contains(query.toLowerCase())) {
      aScore += 2;
    }
    if (a.text.toLowerCase().contains(query.toLowerCase())) {
      aScore += 1;
    }
    if (a.tag != null && a.tag!.toLowerCase().contains(query.toLowerCase())) {
      aScore += 1;
    }
    if (b.title.toLowerCase().contains(query.toLowerCase())) {
      bScore += 2;
    }
    if (b.text.toLowerCase().contains(query.toLowerCase())) {
      bScore += 1;
    }
    if (b.tag != null && b.tag!.toLowerCase().contains(query.toLowerCase())) {
      bScore += 1;
    }
    return bScore - aScore;
  });
  return results;
}