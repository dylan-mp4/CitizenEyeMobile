import 'package:flutter_test/flutter_test.dart';
import 'package:citizen_eye/fileupload.dart';
import 'package:flutter/material.dart';


void main() {
  testWidgets('FileUploadPage should start', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: FileUploadPage(),
    ));

    // Verify that our app starts up correctly.
    expect(find.text('File Upload'), findsOneWidget);
  });

  testWidgets('Process App Video button should be present', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: FileUploadPage(),
    ));

    // Verify that the Process App Video button is present.
    expect(find.text('Process App Video'), findsOneWidget);
  });

  testWidgets('Process External Video button should be present', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: FileUploadPage(),
    ));

    // Verify that the Process External Video button is present.
    expect(find.text('Process External Video'), findsOneWidget);
  });

}