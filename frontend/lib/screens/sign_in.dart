import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kanjou/screens/home.dart';
import 'package:kanjou/utilities/auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  static const routeName = '/sign-in';

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_outlined),
              onPressed: () {
                Navigator.pop(context, true);
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('This is the Sign In Screen'),
            FutureBuilder(
              future: Authentication.initializeFirebase(context: context),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error initializing Firebase');
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return ElevatedButton(
                    onPressed: () async {
                      User? user = await Authentication.signInWithGoogle(context: context);
                      if (user != null) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        );
                      }
                    },
                    child: Text('Sign In with Google'),
                  );
                }
                return CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.orangeAccent,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
