import 'package:cloud_firestore/cloud_firestore.dart';

class NoteSkeleton {
  String title;
  String text; // Change this to raw bytes

  NoteSkeleton({required this.title, required this.text});

  Map<String, dynamic> toMap() {
    return {'title': title, 'text': text};
  }

  NoteSkeleton.fromMap(Map<String, dynamic> noteMap)
      : title = noteMap['title'],
        text = noteMap['text'];
}


class Note {
  String title;
  String text; // Change this to raw bytes
  final DocumentReference reference;

  Note({required this.title, required this.text, required this.reference});

  Map<String, dynamic> toMap() {
    return {'reference': reference.id, 'title': title, 'text': text};
  }

  Note.fromMap(Map<String, dynamic> noteMap)
      : reference = noteMap['reference'],
        title = noteMap['title'],
        text = noteMap['text'];
}

