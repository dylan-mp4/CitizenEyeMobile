import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:projects/settings.dart';
import 'package:projects/settings_data.dart';
import 'package:provider/provider.dart';


void main() {
  testWidgets('SettingsPage has a title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => SettingsData(),
        child: const MaterialApp(home: SettingsPage()),
      ),
    );

    // Verify the title is displayed
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('SettingsPage has a Server IP Address field', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => SettingsData(),
        child: const MaterialApp(home: SettingsPage()),
      ),
    );

    // Verify the Server IP Address field is displayed
    expect(find.text('Server IP Address'), findsOneWidget);
  });

test('updateIpAddress updates the IP address', () {
  // Create an instance of SettingsData
  final settingsData = SettingsData();

  // Define a test IP address
  const testIpAddress = '192.168.1.1';

  // Call updateIpAddress with the test IP address
  settingsData.updateIpAddress(testIpAddress);

  // Check that the IP address was updated correctly
  expect(settingsData.ipAddress, testIpAddress);
});

test('updateAuthToken updates the auth token', () {
  // Create an instance of SettingsData
  final settingsData = SettingsData();

  // Define a test auth token
  const testAuthToken = 'testAuthToken';

  // Call updateAuthToken with the test auth token
  settingsData.updateAuthToken(testAuthToken);

  // Check that the auth token was updated correctly
  expect(settingsData.authToken, testAuthToken);
});

test('Auto Upload setting true and false, saves to settings_data correctly', () {
  // Create an instance of SettingsData
  final settingsData = SettingsData();

  // Define a test auto upload setting
  const testAutoUpload = true;
  const testAutoUpload2 = false;
  // Call updateAutoUpload with the test auto upload setting
  settingsData.updateAutoUpload(testAutoUpload);

  // Check that the auto upload setting was updated correctly for both true and false
  expect(settingsData.autoUpload, testAutoUpload);
  settingsData.updateAutoUpload(testAutoUpload2);
  expect(settingsData.autoUpload, testAutoUpload2);

});

test('addResult adds a result to the results list', () {
  // Create an instance of SettingsData
  final settingsData = SettingsData();

  // Define a test result
  final testResult = {'test': 'result'};

  // Call addResult with the test result
  settingsData.addResult([testResult]);

  // Check that the result was added to the results list
  expect(settingsData.results, [testResult]);
});

test('clearResults clears the results list', () {
  // Create an instance of SettingsData
  final settingsData = SettingsData();

  // Define a test result
  final testResult = {'test': 'result'};

  // Add the test result to the results list
  settingsData.addResult([testResult]);

  // Check that the result was added to the results list
  expect(settingsData.results, [testResult]);
  
  // Call clearResults
  settingsData.clearResults();

  // Check that the results list is empty
  expect(settingsData.results, []);
});


}