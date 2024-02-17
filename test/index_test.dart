import 'package:flutter_test/flutter_test.dart';
import 'package:projects/index.dart';
import 'package:flutter/material.dart';
import 'package:projects/settings.dart';
import 'package:provider/provider.dart';
import 'package:projects/settings_data.dart';
import 'package:mockito/mockito.dart';
import 'package:camera/camera.dart';

class MockCameraController extends Mock implements CameraController {}

void main() {
  testWidgets('Application main building phase, failure could mean major build failures', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our app starts up correctly.
    expect(find.text('Citizen Eye'), findsOneWidget);
  });

  testWidgets('Home page initialized incorrectly, Citizen Eye not found', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => SettingsData(),
        child: const MaterialApp(
          home: MyHomePage(),
        ),
      ),
    );

    // Verify that our app starts up correctly.
    expect(find.text('Citizen Eye'), findsOneWidget);
  });


// Graphical User Interface tests
  testWidgets('Start Recording button should be present', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => SettingsData(),
        child: const MaterialApp(
          home: MyHomePage(),
        ),
      ),
    );

    // Verify that the Start Recording button is present.
    expect(find.text('Start Recording'), findsOneWidget);
  });
  
  testWidgets('Settings button should be present', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => SettingsData(),
        child: const MaterialApp(
          home: MyHomePage(),
        ),
      ),
    );

    // Verify that the Settings button is present.
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });
  
// Navigation Tests
  testWidgets('Settings page should start', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => SettingsData(),
        child: const MaterialApp(
          home: SettingsPage(),
        ),
      ),
    );

    // Verify that the Settings page starts up correctly.
    expect(find.text('Settings'), findsOneWidget);
  });
  //Recording Tests
  // Recording button pressed camera should start recording
  testWidgets('Start Recording button should start recording', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => SettingsData(),
        child: const MaterialApp(
          home: MyHomePage(),
        ),
      ),
    );

    // Tap the Start Recording button and trigger a frame.
    await tester.tap(find.text('Start Recording'));
    await tester.pump();

    // Verify that the camera is recording.
    expect(find.text('Stop Recording'), findsOneWidget);
  });
}