import 'package:flutter/material.dart';

class NoteForm extends StatefulWidget {
  const NoteForm({Key? key, this.noteData}) : super(key: key);

  final Map<String, dynamic>? noteData;

  @override
  _NoteFormState createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  late TextEditingController _titleController;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.noteData?['title'] ?? "");
    _textController = TextEditingController(text: widget.noteData?['text'] ?? "");
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Note'),
        actions: [
          IconButton(
            onPressed: () {/* TODO: Implement Speech-To-Text Functionality */},
            icon: Icon(Icons.mic)
          ),
          IconButton(
            onPressed: () {/* TODO: Implement OCR Functionality */},
            icon: Icon(Icons.document_scanner_outlined)
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Text',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  ...widget.noteData ?? {}, // Append the prefilled data from the widget
                  'title': _titleController.text,
                  'text': _textController.text,
                });
              },
              child: const Text('Add Note'),
            ),
          ],
        ),
      ),
    );
  }
}