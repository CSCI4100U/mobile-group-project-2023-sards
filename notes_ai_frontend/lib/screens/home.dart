import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_ai/utilities/note_model.dart';
import 'package:notes_ai/models/note.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _model = NotesModel();
  final NotesModel notesModel = NotesModel();
  int _selectedIndex = -1; // for selecting, gestureDetector etc
  List<Note> _notes = [];

  bool _searchBoolean = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                onPressed: () {},
                icon: const Icon(Icons.menu),
              );
            },
          ),
          title: _searchBoolean ? _buildSearchField() : const Text(
              "Welcome, [user]!"),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                setState(() {
                  _searchBoolean = !_searchBoolean;
                });
              },
              icon: Icon(_searchBoolean ? Icons.clear : Icons.search),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(child: _buildListOfNotes()
            ),
          ],
        ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Grades!',
        onPressed: (){},
        child: const Icon(Icons.edit_note_sharp),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      decoration: const InputDecoration(
        hintText: "Search...",
      ),
      onSubmitted: (value) {
        // Handle search here
      },
    );
  }

  Widget _buildListOfNotes() {
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(12, 8, 8, 8),
          child: Text(
            "All Notes",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
