import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'dart:convert';
import 'package:citizen_eye/settings_data.dart';

class RecordingUtil {
  CameraController? controller;
  List<String> videoPaths = [];

  RecordingUtil(this.controller);

  Future<void> startRecording(settingsData) async {
    await controller!.startVideoRecording();

    // Stop recording after a duration
    Timer(const Duration(minutes: 1), () async {
      if (controller != null && controller!.value.isRecordingVideo) {
        XFile videoFile = await controller!.stopVideoRecording();
        videoPaths.add(videoFile.path);
        if (settingsData.autoUpload) {
          uploadVideo(videoFile.path, settingsData);
        }
        // Start next recording
        await startRecording(settingsData);
      }
    });
  }

  Future<void> stopRecording(settingsData) async {
    if (controller != null && controller!.value.isRecordingVideo) {
      XFile videoFile = await controller!.stopVideoRecording();
      videoPaths.add(videoFile.path);
      if (kDebugMode) {
        print(settingsData.autoUpload);
      }
      if (settingsData.autoUpload) {
        uploadVideo(videoFile.path, settingsData);
      }
    }
  }

  Future<void> uploadVideo(
      String filePath, SettingsData settingsDataProvider) async {
    if (kDebugMode) {
      print('Attempting to Upload video: $filePath');
    }
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
      if (kDebugMode) {
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
      if (response.statusCode == 200) {
        // Parse the JSON data
        List<dynamic> data = jsonDecode(response.body);

        // Add the result to the provider
        settingsDataProvider.addResult(data);
      } else {
        throw Exception('Failed to upload video');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Upload Failed');
      }
    }
  }
}
