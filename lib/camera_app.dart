import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:projects/settings.dart';
import 'package:projects/record_util.dart';
import 'package:projects/settings_data.dart';
import 'package:provider/provider.dart';

class CameraApp extends StatefulWidget {
  final CameraDescription camera;

  const CameraApp({
    super.key,
    required this.camera,
  });

  @override
  CameraAppState createState() => CameraAppState();
}

class CameraAppState extends State<CameraApp> {
  bool isRecording = false;
  RecordingUtil? recordingUtil;
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.max,
    );
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      recordingUtil = RecordingUtil(_controller);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: Stack(children: [
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: _controller.value.isInitialized
                  ? CameraPreview(_controller)
                  : Container(),
            ),
            Positioned(
              top: 25.0,
              right: 10.0,
              child: IconButton(
                icon: const Icon(Icons.settings,
                    color: Colors.white70, size: 30.0),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: RawMaterialButton(
                        onPressed: () {
                          if (isRecording) {
                            // Stop recording
                            recordingUtil?.stopRecording(
                                Provider.of<SettingsData>(context,
                                    listen: false));
                          } else {
                            // Start recording
                            recordingUtil?.startRecording(
                                Provider.of<SettingsData>(context,
                                    listen: false));
                          }
                          setState(() {
                            isRecording = !isRecording;
                          });
                        },
                        shape: const CircleBorder(),
                        elevation: 2.0,
                        fillColor: Colors.white,
                        padding: const EdgeInsets.all(15.0),
                        child: Icon(
                          isRecording ? Icons.stop : Icons.circle,
                          color: isRecording ? Colors.red : Colors.green,
                          size: 50,
                        )),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
