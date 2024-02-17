import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_data.dart';
import 'package:camera/camera.dart';
import 'camera_app.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (context) => SettingsData(),
      child: FutureBuilder<List<CameraDescription>>(
        future: availableCameras(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final firstCamera = snapshot.data!.first;
            return CameraApp(camera: firstCamera);
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    ),
  );
}