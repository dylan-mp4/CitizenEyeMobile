
import 'package:flutter/material.dart';
import 'settings.dart';
import 'dart:async';
import 'package:camera/camera.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Citizen Eye',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}
class MyHomePageState extends State<MyHomePage> {
  bool isRecording = false;
  CameraController? controller;
  List<CameraDescription> cameras = [];
  List<String> videoPaths = [];

  @override
  void initState() {
    super.initState();
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      if (cameras.isNotEmpty) {
        controller = CameraController(cameras[0], ResolutionPreset.medium);
        controller!.initialize().then((_) {
          if (!mounted) {
            return;
          }
          setState(() {});
        });
      }
    });
  }

  Future<void> startRecording() async {
    await controller!.startVideoRecording();
    setState(() {
      isRecording = true;
    });
    // Stop recording after a duration
    Timer(const Duration(minutes: 1), () async {
      if (controller != null && controller!.value.isRecordingVideo) {
      XFile videoFile = await controller!.stopVideoRecording();
      videoPaths.add(videoFile.path);
      // Start next recording
      await startRecording();
      }
    });
  }
  Future<void> stopRecording() async {
    if (controller != null && controller!.value.isRecordingVideo) {
      XFile videoFile = await controller!.stopVideoRecording();
      videoPaths.add(videoFile.path);
      setState(() {
        isRecording = false; // Set isRecording to false when recording stops
      });
    }
  }
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Citizen Eye'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          if (controller != null && controller!.value.isInitialized)
            Expanded(
              child: AspectRatio(
                aspectRatio: isLandscape ? 1 / controller!.value.aspectRatio : controller!.value.aspectRatio,
                child: CameraPreview(controller!),
              ),
            ),
          if (isRecording)
            ElevatedButton(
              onPressed: stopRecording,
              child: const Text('Stop Recording'),
            )
          else
            ElevatedButton(
              onPressed: startRecording,
              child: const Text('Start Recording'),
            ),
          // Display the list of recorded video paths
          for (var videoPath in videoPaths)
            ListTile(
              title: Text(videoPath),
            ),
        ],
      ),
    );
  }
}