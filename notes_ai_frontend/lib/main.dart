import 'package:flutter/material.dart';
import 'package:notes_ai/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // add custom theme later
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(), // This should call the entry point of the app.
    );
  }
}
