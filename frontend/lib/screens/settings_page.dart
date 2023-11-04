import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);


  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notif = false;
  bool _sync = false;
  bool _theme = false;

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
          title: Text("Settings"),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
              child: SwitchListTile.adaptive(
                  value: _notif,
                  onChanged: (bool value) {
                    setState(() {
                      _notif = value;
                    }
                    // Add push notif function
                    );
                  },
                title: Text("Push Notif"),
                subtitle: Text("Receive Push notifications from our application on a semi regular basis."),
                dense: false,
                controlAffinity: ListTileControlAffinity.trailing,
                contentPadding: EdgeInsetsDirectional.fromSTEB(24, 12, 24, 12),
              ),
            ),
            Padding(padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
              child: SwitchListTile.adaptive(
                value: _sync,
                onChanged: (bool value) {
                  setState(() {
                    _sync = value;
                  }
                  // Add Sync function
                  );
                },
                title: Text("Sync To Cloud"),
                subtitle: Text("Automatically sync your notes to cloud once you are done editing it."),
                dense: false,
                controlAffinity: ListTileControlAffinity.trailing,
                contentPadding: EdgeInsetsDirectional.fromSTEB(24, 12, 24, 12),
              ),
            ),
            Padding(padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
              child: SwitchListTile.adaptive(
                value: _theme,
                onChanged: (bool value) {
                  setState(() {
                    _theme = value;
                  }
                  // Add switch to light mode function
                  );
                },
                title: Text("Light Mode"),
                dense: false,
                controlAffinity: ListTileControlAffinity.trailing,
                contentPadding: EdgeInsetsDirectional.fromSTEB(24, 12, 24, 12),
              ),
            ),
            Padding(padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
              child: ElevatedButton(
                onPressed: (){}, // Add functionality
                child: Text("Import From Cloud"),
                style: ElevatedButton.styleFrom(
                  // Add theme color and font later
                  fixedSize: Size.fromHeight(50),
                ),
              ),
            )
          ],
        ),
    );
  }
}