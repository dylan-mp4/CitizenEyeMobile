import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fileupload.dart';
import 'results.dart';

/// Represents the settings page of the application.
/// Allows the user to configure various settings such as server IP address, authentication token, and auto upload feature.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}
class _SettingsPageState extends State<SettingsPage> {
  bool autoUpload = true;
  String ipAddress = 'http://10.0.2.2:8000/upload/';
  String authToken = '';
  @override
  void initState() {
    super.initState();
    loadStates();
  }

  void loadStates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool initialAutoUpload = prefs.getBool('autoUpload') ?? true;
    String initialIpAddress = prefs.getString('ipAddress') ?? 'http://10.0.2.2:8000/upload/';
    String initialAuthToken = prefs.getString('authToken') ?? '';
    setState(() {
      autoUpload = initialAutoUpload;
      ipAddress = initialIpAddress;
      authToken = initialAuthToken;
    });
  }
  @override
  Widget build(BuildContext context) {
    // Build the settings page UI using Scaffold widget
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Results'),
            onTap: () {
              // Navigate to the results page when the "Results" item is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ResultsPage(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Server IP Address'),
            subtitle: TextField(
              keyboardType:
                  TextInputType.url,
              decoration: InputDecoration(
                hintText: ipAddress,
              ),
              onChanged: (value) async {
                // Update the server IP address in the settings data provider
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('ipAddress', value);
                if (kDebugMode) {
                  print("Server IP changed:$value");
                }
              },
            ),
          ),
          ListTile(
            title: const Text('Auth Token'),
            subtitle: TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: authToken,
              ),
              onChanged: (value) async {
                // Update the authentication token in the settings data provider
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('authToken', value);
                if (kDebugMode) {
                  print("Auth value changed:$value");
                }
              },
            ),
          ),
          ListTile(
            title: const Text('Manual Video Upload'),
            onTap: () {
              // Navigate to the file upload page when the "Manual Video Upload" item is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FileUploadPage(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Auto Upload'),
            trailing: Switch(
                value: autoUpload,
              onChanged: (value) async {
                // Update the auto upload setting in the settings data provider
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('autoUpload', value);
                if (kDebugMode) {
                  print("Auto upload:$value");
                }
                setState((){
                  autoUpload = value;
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              Set<String> keys = prefs.getKeys();
              for (String key in keys) {
                print('key: $key, value: ${prefs.get(key)}');
              }
            },
            child: const Text('Test Connection'),
          ),
        ],
      ),
    );
  }
}
