import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'fileupload.dart';
import 'package:provider/provider.dart';
import 'settings_data.dart';


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
            title: const Text('Server IP Address'),
            subtitle: TextField(
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                hintText: 'Enter IP Address',
              ),
              onChanged: (value) {
                Provider.of<SettingsData>(context, listen: false).updateIpAddress(value);
                if (kDebugMode) {
                  print(value);
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
                  print(value);
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
        ],
      ),
    );
  }
}