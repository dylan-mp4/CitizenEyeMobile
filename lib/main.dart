import 'package:flutter/material.dart';
import 'index.dart';
import 'package:provider/provider.dart';
import 'settings_data.dart';
import 'package:camera/camera.dart';

late CameraController controller;
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SettingsData(),
      child: const MyApp(),
    ),
  );
}