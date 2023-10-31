import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kanjou/screens/create_note.dart';
import 'package:kanjou/utilities/note_model.dart';
import 'package:kanjou/models/note.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = -1; // for selecting, gestureDetector etc
  bool _searchBoolean = false;

  @override
  Widget build(BuildContext context) {
    CollectionReference notesCollection =
        FirebaseFirestore.instance.collection('notes');

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
        title: _searchBoolean
            ? _buildSearchField()
            : const Text("Welcome, [user]!"),
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
          Expanded(child: _buildListOfNotes()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Notes!',
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NoteForm()));
        },
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
