import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_data.dart';
import 'fileupload.dart';
import 'package:camera/camera.dart';
import 'camera_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'welcome.dart';
/// The main entry point of the application.
///
/// This function initializes the Flutter application and sets up the necessary bindings.
/// It retrieves the value of 'firstTime' from shared preferences and determines whether to display the WelcomeScreen or the CameraApp.
/// If 'firstTime' is null or true, the WelcomeScreen is displayed, otherwise the CameraApp is displayed.
///
/// Parameters:
///   - None
///
/// Returns:
///   - None
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? isFirstTime = prefs.getBool('firstTime');
if (isFirstTime == null || isFirstTime == true) {    
    await prefs.setBool('firstTime', false);
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SettingsData()),
        ChangeNotifierProvider(create: (context) => UploadModel()), // Add the UploadModel provider
      ],
      child: FutureBuilder<List<CameraDescription>>(
        future: availableCameras(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final firstCamera = snapshot.data!.first;
            // If it's the first time, display the WelcomeScreen
            // Otherwise, display the CameraApp
            return MaterialApp(
              home: isFirstTime ?? true
                  ? WelcomeScreen(firstCamera: firstCamera)
                  : CameraApp(camera: firstCamera),
            );
          } else {
            return const MaterialApp(
              home: CircularProgressIndicator(),
            );
          }
        },
      ),
    ),
  );
}