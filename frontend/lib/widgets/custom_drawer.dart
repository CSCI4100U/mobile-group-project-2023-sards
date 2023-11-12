import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kanjou/screens/settings_page.dart';
import 'package:kanjou/screens/sign_in.dart';
import 'package:kanjou/services/auth.dart';
import 'package:kanjou/services/classify.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  User? _user;

  @override
  void initState() {
    _user = FirebaseAuth.instance.currentUser;
    super.initState();
  }

  Widget signedInWidgets(BuildContext context, User? user) {
    if (user == null) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20.0),
          child: Divider(color: Color.fromARGB(255, 101, 101, 101)),
        ),
        user.photoURL != null
            ? ClipOval(
                child: Material(
                  color: Colors.transparent,
                  child: Image.network(
                    user!.photoURL!,
                    fit: BoxFit.fitHeight,
                    height: 50,
                    width: 50,
                  ),
                ),
              )
            : const ClipOval(
                child: Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
        const SizedBox(height: 16.0),
        Text(
          user.displayName!,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          user.email!,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          // DrawerHeader(
          //   child: Column(
          //     children: [
          //       Text(
          //         widget._user.displayName!,
          //         style: const TextStyle(
          //           fontSize: 24,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //       Text(
          //         widget._user.email!,
          //         style: const TextStyle(
          //           fontSize: 16,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          ListTile(
            title: Text(_user == null ? 'Sign In' : "Sign Out"),
            onTap: () async {
              if (_user != null) {
                await Authentication.signOut(context: context);
                setState(() {
                  _user = FirebaseAuth.instance.currentUser;
                });
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignIn()),
                );
              }
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
            ),
            onPressed: () {
              NotesClassifier.classifyNotes(context);
            },
            child: const Text(
              'Categorize Notes',
              style: TextStyle(color: Colors.black),
            ),
          ),
          signedInWidgets(context, _user)
        ],
      ),
    );
  }
}
