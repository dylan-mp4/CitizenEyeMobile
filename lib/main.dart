import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_data.dart';
import 'package:camera/camera.dart';
import 'camera_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'welcome.dart';  

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? isFirstTime = prefs.getBool('firstTime');

  runApp(
    ChangeNotifierProvider(
      create: (context) => SettingsData(),
      child: FutureBuilder<List<CameraDescription>>(
        future: availableCameras(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final firstCamera = snapshot.data!.first;

            // If it's the first time, display the WelcomeScreen
            // Otherwise, display the CameraApp
            return MaterialApp(
  home: isFirstTime ?? true ? WelcomeScreen(firstCamera: firstCamera) : CameraApp(camera: firstCamera),
            );
          } else {
            return MaterialApp(
              home: const CircularProgressIndicator(),
            );
          }
        },
      ),
    ),
  );

  if (isFirstTime != null) {
    // If it's not the first time, update the value
    await prefs.setBool('firstTime', false);
  }
}