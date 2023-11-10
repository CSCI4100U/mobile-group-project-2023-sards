import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  final String _notifKey = 'notifications';
  final String _syncKey = 'sync';
  final String _themeKey = 'lightmode';
  late SharedPreferences prefs;
  bool _notifications = false;
  bool _sync = false;
  bool _lightmode = false;

  SettingsProvider() {
    SharedPreferences.getInstance().then((SharedPreferences value) {
      prefs = value;
      try {
        _notifications = prefs.getBool(_notifKey) ?? false;
        _sync = prefs.getBool(_syncKey) ?? false;
        _lightmode = prefs.getBool(_themeKey) ?? false;
      } catch (error) {
        debugPrint(error.toString());
      }
    });
  }

  // Getters
  bool get notifications => _notifications;
  bool get sync => _sync;
  bool get lightmode => _lightmode;

  // Setters
  set notifications(bool val){
    _notifications = val;
    notifyListeners();
    prefs.setBool(_notifKey, val);
  }
  set sync(bool val){
    _sync = val;
    notifyListeners();
    prefs.setBool(_syncKey, val);
  }
  set lightmode(bool val){
    _lightmode = val;
    notifyListeners();
    prefs.setBool(_themeKey, val);
  }
}
