import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'fileupload.dart';
import 'package:provider/provider.dart';
import 'settings_data.dart';
import 'results.dart';


/// Represents the settings page of the application.
/// Allows the user to configure various settings such as server IP address, authentication token, and auto upload feature.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
                  builder: (context) => ResultsPage(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Server IP Address'),
            subtitle: TextField(
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                hintText: 'Enter IP Address',
              ),
              onChanged: (value) {
                // Update the server IP address in the settings data provider
                Provider.of<SettingsData>(context, listen: false).updateIpAddress(value);
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
              decoration: const InputDecoration(
                hintText: 'Enter Auth Token',
              ),
              onChanged: (value) {
                // Update the authentication token in the settings data provider
                Provider.of<SettingsData>(context, listen: false).updateAuthToken(value);
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
              value: Provider.of<SettingsData>(context).autoUpload,
              onChanged: (value) {
                // Update the auto upload setting in the settings data provider
                Provider.of<SettingsData>(context, listen: false).updateAutoUpload(value);
                if (kDebugMode) {
                  print("Auto upload:$value");
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}