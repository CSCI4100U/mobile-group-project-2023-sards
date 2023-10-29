class Note{
  int? id;
  String title;
  String text;

  Note({this.id, required this.title, required this.text});

  Map<String, dynamic> toMap(){
    return {'id': id, 'title': title, 'text': text};
  }

  Note.fromMap(Map<String, dynamic> noteMap):
    id = noteMap['id'], title = noteMap['title'], text = noteMap['text'];

}