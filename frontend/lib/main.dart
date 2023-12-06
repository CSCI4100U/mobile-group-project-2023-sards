import 'package:flutter/material.dart';
import 'package:kanjou/screens/home.dart';
import 'package:kanjou/providers/note_provider.dart';
import 'package:kanjou/providers/settings_provider.dart';
import 'package:kanjou/theme/theme_manager.dart';
import 'package:kanjou/services/connectivity.dart';
import 'package:provider/provider.dart';
import 'package:kanjou/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  notificationService();

  ConnectionStatusSingleton connectionStatus =
      ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeManager(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
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
        theme: themeManager.isDarkMode! ? themeManager.darkTheme : themeManager.lightTheme,
        home: const HomePage(),
      ),
    );
  }
}
