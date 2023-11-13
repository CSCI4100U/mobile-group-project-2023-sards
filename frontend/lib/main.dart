import 'package:flutter/material.dart';
import 'package:kanjou/screens/home.dart';
import 'package:kanjou/providers/note_provider.dart';
import 'package:kanjou/providers/settings_provider.dart';

import 'package:json_theme/json_theme.dart';
import 'package:kanjou/services/connectivity.dart';

import 'package:provider/provider.dart';

import 'package:flutter/services.dart'; // For rootBundle
import 'dart:convert'; // For jsonDecode
import 'package:kanjou/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the Theme
  final themeStr = await rootBundle.loadString('assets/theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  notificationService();

  ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();

  runApp(MyApp(theme: theme));
}

class MyApp extends StatelessWidget {
  final ThemeData theme;

  const MyApp({Key? key, required this.theme}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => NotesProvider()),
          ChangeNotifierProvider(
            create: (context) => SettingsProvider(),
            lazy: false,
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          // add custom theme later
          theme: theme,
          home:
              const HomePage(), // This should call the entry point of the app.
        ));
  }
}
