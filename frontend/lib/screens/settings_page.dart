import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SharedPreferences prefs;
  final String _notifKey = 'notifications';
  final String _syncKey = 'sync';
  final String _themeKey = 'lightmode';
  bool _notif = false;
  bool _sync = false;
  bool _theme = false;

  // @override
  // void initState() async{
  //   super.initState();
  //   prefs = await SharedPreferences.getInstance();
  //   try{
  //     _notif = prefs.getBool(_notifKey) ?? false;
  //     _sync = prefs.getBool(_syncKey) ?? false;
  //     _theme = prefs.getBool(_themeKey) ?? false;
  //   } catch(error){
  //     debugPrint(error.toString());
  //   }
  // }

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
                tooltip: MaterialLocalizations
                    .of(context)
                    .openAppDrawerTooltip,
              );
            },
          ),
          title: const Text("Settings", style:
          TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25
            ),
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
              child: SwitchListTile.adaptive(
                  value: _notif,
                  onChanged: (bool value) {
                    setState(() {
                      _notif = value;
                      prefs.setBool(_notifKey, value);
                    }
                    // Add push notif function
                    );
                  },
                title: const Text("Push Notifications",
                  style:
                  TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                ),
                subtitle: const Text("Receive Push notifications from our application on a semi regular basis."),
                dense: false,
                controlAffinity: ListTileControlAffinity.trailing,
                contentPadding: const EdgeInsetsDirectional.fromSTEB(24, 12, 24, 12),
                activeColor: const Color.fromRGBO(249, 207, 88, 100),
              ),
            ),
            Padding(padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
              child: SwitchListTile.adaptive(
                value: _sync,
                onChanged: (bool value) {
                  setState(() {
                    _sync = value;
                    prefs.setBool(_syncKey,value);
                  }
                  // Add Sync function
                  );
                },
                title: const Text("Sync To Cloud",
                  style:
                  TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                subtitle: const Text("Automatically sync your notes to cloud once you are done editing it."),
                dense: false,
                controlAffinity: ListTileControlAffinity.trailing,
                contentPadding: const EdgeInsetsDirectional.fromSTEB(24, 12, 24, 12),
                activeColor: const Color.fromRGBO(249, 207, 88, 100),
              ),
            ),
            Padding(padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
              child: SwitchListTile.adaptive(
                value: _theme,
                onChanged: (bool value) {
                  setState(() {
                    _theme = value;
                    prefs.setBool(_themeKey, value);
                  }
                  // Add switch to light mode function
                  );
                },
                title: const Text("Light Mode",
                  style:
                  TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                dense: false,
                controlAffinity: ListTileControlAffinity.trailing,
                contentPadding: const EdgeInsetsDirectional.fromSTEB(24, 12, 24, 12),
                activeColor: const Color.fromRGBO(249, 207, 88, 100),
              ),
            ),
            Padding(padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
              child: ElevatedButton(
                onPressed: (){}, // Add functionality
                style: ElevatedButton.styleFrom(
                  // Add theme color and font later
                  fixedSize: const Size.fromHeight(50),
                  backgroundColor: const Color.fromRGBO(249, 207, 88, 100),
                ),
                child: const Text("Import From Cloud",
                  style:
                  TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
            const Align(
              alignment: AlignmentDirectional(-1.00, 1.00),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12, 30, 24, 12),
                child: Text(
                  "App Version",
                  style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,)
                ),
              ),
            ),
            const Align(
              alignment: AlignmentDirectional(-1.00, 1.00),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12, 6, 0, 0),
                child: Text(
                    "v0.0.1",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,)
                ),
              ),
            ),
          ],
        ),
    );
  }
}