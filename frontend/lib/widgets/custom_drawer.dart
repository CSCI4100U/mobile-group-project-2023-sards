import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kanjou/screens/settings_page.dart';
import 'package:kanjou/screens/sign_in.dart';
import 'package:kanjou/services/auth.dart';

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

  @override
  Widget build(BuildContext context) {
    double drawerWidth = MediaQuery.of(context).size.width * 0.5; // Adjust the width as a percentage of the screen width

    return SizedBox(
      width: drawerWidth,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(height: 50), // Space at the top of the drawer
            ListTile(
              leading: Icon(_user == null ? Icons.login : Icons.logout),
              title: Text(_user == null ? 'Sign In' : 'Sign Out'),
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
            // Additional list tiles for other pages...
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            // Add more list tiles as needed...
          ],
        ),
      ),
    );
  }
}
