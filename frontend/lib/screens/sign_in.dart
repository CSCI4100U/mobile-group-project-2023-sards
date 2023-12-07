import 'package:flutter/material.dart';
import 'package:kanjou/screens/home.dart';
import 'package:kanjou/services/auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  static const routeName = '/sign-in';

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow, // Updated color
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_outlined, color: Colors.black), // Icon color changed to black for visibility
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow, // Updated color
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Please sign in to continue',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey, // Kept grey for readability
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: FutureBuilder(
                future: Authentication.initializeFirebase(context: context),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error initializing Firebase');
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return ElevatedButton(
                      onPressed: () async {
                        await Authentication.signInWithGoogle(
                          context: context,
                        );
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.yellow, // Updated color
                        onPrimary: Colors.black, // Text color on the button
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      child: Text(
                        'Sign In with Google',
                        style: TextStyle(
                          fontSize: 18, // Updated font size
                          color: Colors.black, // Text color for visibility
                        ),
                      ),
                    );
                  }
                  return CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.yellow, // Updated color
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 40),
            Container(
              alignment: Alignment.center,
              child: Text(
                'More Sign-In Options Coming Soon',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.yellow, // Updated color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
