import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsData extends ChangeNotifier {
  String _ipAddress = '';
  String _authToken = '';
  bool _autoUpload = false;
  List<Map<String, dynamic>> _results = [];

SettingsData() {
  _results = [];
  savePreferences();
  loadPreferences();
}

  bool get autoUpload => _autoUpload;
  String get ipAddress => _ipAddress;
  String get authToken => _authToken;
  List<Map<String, dynamic>> get results => _results;

  void updateIpAddress(String newIp) {
    _ipAddress = newIp;
    savePreferences();
    notifyListeners();
  }

  void updateAuthToken(String newToken) {
    _authToken = newToken;
    savePreferences();
    notifyListeners();
  }

  void updateAutoUpload(bool value) {
    _autoUpload = value;
    savePreferences();
    notifyListeners();
  }

  void addResult(List<dynamic> data) {
    for (var item in data) {
    if (item is Map<String, dynamic>) {
      item['index'] = _results.length;
      _results.add(item);
    }
  }
    savePreferences();
    notifyListeners();
  }

  void clearResults() {
    _results.clear();
    notifyListeners();
  }
  void removeResult(index) {
  if (index >= 0 && index < _results.length) {
    _results.removeAt(index);

    // Update the indices of all records after the deleted one
    for (int i = index; i < _results.length; i++) {
      _results[i]['index'] = i;
    }
  } else {
    print('No result found at the provided index');
  }
  notifyListeners();
}

Future<void> savePreferences() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('ipAddress', _ipAddress);
    prefs.setString('authToken', _authToken);
    prefs.setBool('autoUpload', _autoUpload);
    String resultsJson = jsonEncode(_results);
    prefs.setString('results', resultsJson);
  } catch (e) {
    if (kDebugMode) {
      print('Error saving preferences: $e');
    }
  }
}

Future<void> loadPreferences() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _ipAddress = prefs.getString('ipAddress') ?? '';
    _authToken = prefs.getString('authToken') ?? '';
    _autoUpload = prefs.getBool('autoUpload') ?? true;
    String resultsJson = prefs.getString('results') ?? '[]';
    _results = List<Map<String, dynamic>>.from(jsonDecode(resultsJson));
  } catch (e) {
    if (kDebugMode) {
      print('Error loading preferences: $e');
    }
  }
  notifyListeners();
}
}