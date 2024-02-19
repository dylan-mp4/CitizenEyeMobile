import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'dart:convert';
import 'package:citizen_eye/settings_data.dart';
import 'package:citizen_eye/location.dart';
import 'package:location/location.dart';

/// A utility class for recording videos using a camera controller.
class RecordingUtil {
  CameraController? controller;
  List<String> videoPaths = [];

  /// Constructs a [RecordingUtil] instance with the given [controller].
  RecordingUtil(this.controller);

  /// A service for obtaining the device's location.
  LocationService locationService = LocationService();
  LocationData? startLocation;
  LocationData? endLocation;

  /// Starts recording videos with the specified [settingsData].
  ///
  /// The recording will automatically stop after a duration of one minute.
  /// If [autoUpload] is enabled in [settingsData], the recorded video will be uploaded.
  /// After stopping the recording, the method will recursively start a new recording. Unless interrupted by the user, this process will continue indefinitely.
  Future<void> startRecording(settingsData) async {
    await controller!.startVideoRecording();
    startLocation = await locationService.getLocation();
    print(startLocation);
    Timer(const Duration(minutes: 1), () async {
      if (controller != null && controller!.value.isRecordingVideo) {
        XFile videoFile = await controller!.stopVideoRecording();
        endLocation = await locationService.getLocation();
        print(endLocation);
        videoPaths.add(videoFile.path);
        if (settingsData.autoUpload) {
          uploadVideo(videoFile.path, settingsData, startLocation, endLocation);
        }
        await startRecording(settingsData);
      }
    });
  }

  /// Stops the current video recording.
  ///
  /// If [autoUpload] is enabled in [settingsData], the recorded video will be uploaded. otherwise, it will be just be saved to local storage cache.
  Future<void> stopRecording(settingsData) async {
    if (controller != null && controller!.value.isRecordingVideo) {
      XFile videoFile = await controller!.stopVideoRecording();
      endLocation = await locationService.getLocation();

      videoPaths.add(videoFile.path);
      if (kDebugMode) {
        print(endLocation);
      }
      if (settingsData.autoUpload) {
        uploadVideo(videoFile.path, settingsData, startLocation, endLocation);
      }
    }
  }

  /// Uploads the video at the specified [filePath] using the provided [settingsDataProvider].
  ///
  /// The video is uploaded to the URL 'http://10.0.2.2:8000/upload/'.
  /// The uploaded video's content type is set to 'video/mp4'.
  /// If the upload is successful, the response data is parsed and added to the [settingsDataProvider].
  /// If the upload fails, an exception is thrown.
  Future<void> uploadVideo(String filePath, SettingsData settingsDataProvider,
      LocationData? startLocation, LocationData? endLocation) async {
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
      request.fields['start_latitude'] = startLocation?.latitude.toString() ?? '';
      request.fields['start_longitude'] = startLocation?.longitude.toString() ?? '';
      request.fields['end_latitude'] = endLocation?.latitude.toString() ?? '';
      request.fields['end_longitude'] = endLocation?.longitude.toString() ?? '';

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (kDebugMode) {
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
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
