import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kanjou/theme/theme_manager.dart';
import '../providers/settings_provider.dart';
import '../services/sync.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    SettingsProvider providerSettings = Provider.of<SettingsProvider>(context);
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
              color: const Color(0xFFE7D434)
            );
          },
        ),
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
            child: SwitchListTile.adaptive(
              value: providerSettings.notifications,
              onChanged: (bool value) {
                providerSettings.notifications = value;
                // Add push notif function
              },
              title: const Text(
                "Push Notifications",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              subtitle: const Text(
                  "Receive Push notifications from our application on a semi regular basis."),
              dense: false,
              controlAffinity: ListTileControlAffinity.trailing,
              contentPadding:
                  const EdgeInsetsDirectional.fromSTEB(24, 12, 24, 12),
              activeColor: const Color(0xFFE7D434),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
            child: SwitchListTile.adaptive(
              value: providerSettings.sync,
              onChanged: (bool value) {
                providerSettings.sync = value;

                // Add Sync function
              },
              title: const Text(
                "Sync To Cloud",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              subtitle: const Text(
                  "Automatically sync your notes to cloud once you are done editing it."),
              dense: false,
              controlAffinity: ListTileControlAffinity.trailing,
              contentPadding:
                  const EdgeInsetsDirectional.fromSTEB(24, 12, 24, 12),
              activeColor:  const Color(0xFFE7D434),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
            child: SwitchListTile.adaptive(
              value: providerSettings.lightmode,
              onChanged: (bool value) {
                providerSettings.lightmode = value;
                themeManager.toggleTheme(); // Toggle the theme here
              },
              title: const Text(
                "Light Mode",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              dense: false,
              controlAffinity: ListTileControlAffinity.trailing,
              contentPadding:
                  const EdgeInsetsDirectional.fromSTEB(24, 12, 24, 12),
              activeColor: const Color(0xFFE7D434),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
            child: ElevatedButton(
              onPressed: () {
                Sync.importFromCloud(context).then((val){

                });
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size.fromHeight(50),
                backgroundColor: const Color(0xFFE7D434),
                onPrimary: const Color(0xFF000000),
              ),
              child: const Text(
                "Import From Cloud",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
          const Align(
            alignment: AlignmentDirectional(-1.00, 1.00),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12, 30, 24, 12),
              child: Text("App Version",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  )),
            ),
          ),
          const Align(
            alignment: AlignmentDirectional(-1.00, 1.00),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12, 6, 0, 0),
              child: Text("v0.0.1",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
