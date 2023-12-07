import 'package:flutter_quill/flutter_quill.dart';

class Note {
  String title;
  String text;
  String id;
  String date;
  String? tag;

  Note(
      {required this.title,
      required this.text,
      required this.id,
      required this.date,
      this.tag});

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'text': text, 'date': date, 'tag': tag};
  }

  Note.fromMap(Map<String, dynamic> noteMap)
      : id = noteMap['id'],
        title = noteMap['title'],
        text = noteMap['text'],
        date = noteMap['date'],
        tag = noteMap['tag'];
}
