import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'fileupload.dart';
import 'package:provider/provider.dart';
import 'settings_data.dart';
import 'results.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Results'),
            onTap: () {
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