/// -----------------------------------------------------
/// 1. Use this as the entry point to the application.
/// 2. Create files as necessary under the same directory.
/// 3. Create separate files for each functionality/screen
/// -----------------------------------------------------

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Set theme here if you wish to
      home: Placeholder(), // This should call the entry point of the app.
    );
  }
}
