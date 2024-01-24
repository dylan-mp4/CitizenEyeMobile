// fileupload.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

class FileUploadPage extends StatefulWidget {
  const FileUploadPage({super.key});

  @override
  FileUploadPageState createState() => FileUploadPageState();
}

class FileUploadPageState extends State<FileUploadPage> {
  List<Map<String, dynamic>> results = [];
  void displayResults() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp4'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);

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
          var data = jsonDecode(response.body);

          // Update the results list
          setState(() {
            results = List<Map<String, dynamic>>.from(data);
          });
        }
      } else {
        // User canceled the picker
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    onPressed: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['mp4'],
                      );

                      if (result != null) {
                        File file = File(result.files.single.path!);

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
                        var response =
                            await http.Response.fromStream(streamedResponse);

                        if (response.statusCode == 200) {
                          // Parse the JSON data
                          var data = jsonDecode(response.body);

                          // Update the results list
                          setState(() {
                            results = List<Map<String, dynamic>>.from(data);
                          });
                        }
                      } else {
                        // User canceled the picker
                      }
                    },
                    child: const Text('Select and Upload Video'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: displayResults,
                    child: const Text('Upload and Process Video'),
                  ),
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
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('License Plate')),
                  DataColumn(label: Text('Score')),
                ],
                rows: results
                    .map((result) => DataRow(cells: [
                          DataCell(Text(result['License Plate'] ?? '')),
                          DataCell(Text(result['Score'].toString())),
                        ]))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
