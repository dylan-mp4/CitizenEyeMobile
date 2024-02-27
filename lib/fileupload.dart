// fileupload.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:citizen_eye/settings_data.dart';
import 'dart:convert';

/// A page for uploading and processing video files.
///
/// This page allows the user to upload a video file, either from the app's storage or from an external source.
/// The uploaded video file is sent to a server for processing, and the results are displayed in a table.
import 'package:provider/provider.dart';
// local ngrok server
String uri = 'https://winning-merely-dodo.ngrok-free.app/upload/';
// localhost
// String uri = 'http://10.0.2.2:8000/upload/';
class FileUploadPage extends StatefulWidget {
  const FileUploadPage({super.key});

  @override
  FileUploadPageState createState() => FileUploadPageState();
}

enum UploadStatus { idle, uploading, processing, completed, failed }

class UploadModel with ChangeNotifier {
  UploadStatus _status = UploadStatus.idle;

  UploadStatus get status => _status;

  void setStatus(UploadStatus status) {
    _status = status;
    notifyListeners();
  }
}

class FileUploadPageState extends State<FileUploadPage> {
  List<dynamic> results = [];
  String? selectedFilePath;

  Future<void> selectFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp4'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        setState(() {
          selectedFilePath = file.path;
        });
      } else {
        // User canceled the picker
        print('User canceled the picker');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  Future<void> uploadFile(SettingsData settingsDataProvider, UploadModel uploadModel) async {
    if (selectedFilePath != null) {
      uploadModel.setStatus(UploadStatus.processing);
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(uri),
      );
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        selectedFilePath!,
        contentType: MediaType('video', 'mp4'),
      ));
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        uploadModel.setStatus(UploadStatus.processing);
        var data = jsonDecode(response.body);
        List<dynamic> rdata = jsonDecode(response.body);
        settingsDataProvider.addResult(rdata);

        setState(() {
          results = List<dynamic>.from(data);
        });
        uploadModel.setStatus(UploadStatus.completed);
      } else {
        uploadModel.setStatus(UploadStatus.failed);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
     var settingsDataProvider = Provider.of<SettingsData>(context);
      var uploadModel = Provider.of<UploadModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Upload'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Upload a Video',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Form(
              child: Column(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: selectFile,
                    child: const Text('Select Video'),
                  ),
                  if (selectedFilePath != null) ...[
                    Text('Selected file: $selectedFilePath'),
                    ElevatedButton(
                      onPressed: () => uploadFile(settingsDataProvider, uploadModel),
                      child: const Text('Upload Video'),
                    ),
                    Consumer<UploadModel>(
      builder: (context, uploadModel, child) {
        switch (uploadModel.status) {
          case UploadStatus.idle:
            return Text('Idle');
          case UploadStatus.uploading:
            return Text('Uploading...');
          case UploadStatus.processing:
            return Text('Processing...');
          case UploadStatus.completed:
            return Text('Upload completed');
          case UploadStatus.failed:
            return Text('Upload failed');
          default:
            return Container();
        }
      },
    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Results:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          'License Plate',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Score',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                    rows: results
                        .map<DataRow>((result) => DataRow(
                              cells: <DataCell>[
                                DataCell(
                                    Text(result['License Plate'] ?? 'N/A')),
                                DataCell(Text(
                                    (result['Score'] ?? 'N/A').toString())),
                              ],
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
