
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:projects/settings_data.dart';
import 'package:provider/provider.dart';
import 'settings.dart';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

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
Future<void> uploadVideo(String filePath, BuildContext context) async {
  print('Attempting to Upload video: $filePath');
  try {
    File file = File(filePath);

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.0.2.2:8000/upload/'),
    );
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      file.path,
      contentType: MediaType('video', 'mp4'),
    ));
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      // Parse the JSON data
      List<dynamic> data = jsonDecode(response.body);

      // Get the provider
      var settingsDataProvider = Provider.of<SettingsData>(context, listen: false);

      // Add the result to the provider
      settingsDataProvider.addResult(data);
    } else {
      throw Exception('Failed to upload video');
    }
  } catch (e) {
    print('Exception occurred: $e');
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
        if (Provider.of<SettingsData>(context, listen: false).autoUpload) {
      uploadVideo(videoFile.path, context);
  }
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
          if (Provider.of<SettingsData>(context, listen: false).autoUpload) {
    uploadVideo(videoFile.path, context);
  }
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