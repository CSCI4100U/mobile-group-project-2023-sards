import 'package:flutter/material.dart';
import 'package:kanjou/screens/create_note.dart';
import 'package:kanjou/utilities/note_model.dart';
import 'package:kanjou/models/note.dart';
import 'package:kanjou/screens/settingsPage.dart';
import 'package:kanjou/screens/logIn.dart';

import 'package:cloud_firestore/cloud_firestore.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = -1; // for selecting, gestureDetector etc

  final _model = NotesModel();
  final NotesModel notesModel = NotesModel();
  List<Note> _notes = [];

  bool _searchBoolean = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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

  @override
  Widget build(BuildContext context) {
    CollectionReference notesCollection =
    FirebaseFirestore.instance.collection('notes');

    return Scaffold(
      appBar: AppBar(
        title: _searchBoolean ? _buildSearchField() : const Text(
          "Welcome, [user]!", // add username later
        ),
        actions: <Widget>[
          IconButton(onPressed: (){
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
                child: Text("Account details here later")
            ),
            ListTile(
              title: const Text('Settings'),
              selected: _selectedIndex == 0,
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage())
                );
              },
            ),
            ListTile(
              title: const Text('Log In'),
              selected: _selectedIndex == 0,
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LogIn())
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

