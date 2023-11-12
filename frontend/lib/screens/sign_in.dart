import 'package:flutter/material.dart';
import 'package:kanjou/screens/home.dart';
import 'package:kanjou/services/auth.dart';

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
      body: Stack(
        children: [
          // Background image from URL
          Image.network(
            'https://assets-global.website-files.com/61a05ff14c09ecacc06eec05/61f59d883d87115bdf3f85d2_Full_Guide_to_Note_Taking_Methods_1.png', // Replace with the URL of your image
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40), // Adjust the height as needed
                Text(
                  'Join Us Today to Get Started with Your Own AI Note-Taker',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24, // Adjust the font size
                    fontWeight: FontWeight.bold, // Make the text bold
                    color: Colors.white, // Text color on top of the image
                  ),
                ),
                SizedBox(height: 20),
                FutureBuilder(
                  future: Authentication.initializeFirebase(context: context),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error initializing Firebase');
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
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
                          primary: Colors
                              .yellow, // Set the button background color to yellow
                        ),
                        child: Text(
                          'Sign In with Google',
                          style: TextStyle(
                            color: Colors
                                .black, // Set the text color to black for better visibility on a yellow background
                          ),
                        ),
                      );
                    }
                    return CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.orangeAccent,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
