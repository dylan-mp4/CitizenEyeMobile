import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A class that represents the settings data.
/// 
/// This class extends the [ChangeNotifier] class, allowing it to notify listeners when its properties change.
/// It stores and manages various settings such as IP address, authentication token, auto-upload option, and results.
class SettingsData extends ChangeNotifier {
  String _ipAddress = '';
  String _authToken = '';
  bool _autoUpload = false;
  bool _firstTime = true;
  List<Map<String, dynamic>> _results = [];

  /// Constructs a new instance of [SettingsData].
  /// 
  /// It initializes the [_results] list, saves the preferences, and loads the preferences.
  SettingsData() {
    _results = [];
    savePreferences();
    loadPreferences();
  }

  /// Gets the auto-upload option.
  bool get autoUpload => _autoUpload;

  /// Gets the first time flag.
  bool get firstTime => _firstTime;

  /// Gets the IP address.
  String get ipAddress => _ipAddress;

  /// Gets the authentication token.
  String get authToken => _authToken;

  /// Gets the list of results.
  List<Map<String, dynamic>> get results => _results;

  /// Updates the IP address with the provided [newIp].
  /// 
  /// It saves the preferences and notifies the listeners.
  void updateIpAddress(String newIp) {
    _ipAddress = newIp;
    savePreferences();
    notifyListeners();
  }

  /// Updates the authentication token with the provided [newToken].
  /// 
  /// It saves the preferences and notifies the listeners.
  void updateAuthToken(String newToken) {
    _authToken = newToken;
    savePreferences();
    notifyListeners();
  }

  /// Updates the auto-upload option with the provided [value].
  /// 
  /// It saves the preferences and notifies the listeners.
  void updateAutoUpload(bool value) {
    _autoUpload = value;
    savePreferences();
    notifyListeners();
  }

  /// Updates the first time flag with the provided [value].
  /// 
  /// It saves the preferences and notifies the listeners.
  void updateFirstTime(bool value) {
    _firstTime = value;
    savePreferences();
    notifyListeners();
  }

  /// Adds a result to the list of results.
  /// 
  /// The [data] parameter should be a list of dynamic objects.
  /// Each object should be a map with string keys and dynamic values.
  /// The 'index' key is automatically added to each map with the index of the result in the list.
  /// It saves the preferences and notifies the listeners.
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

  /// Clears all the results from the list.
  /// 
  /// It notifies the listeners.
  void clearResults() {
    _results.clear();
    notifyListeners();
  }

  /// Removes a result from the list at the provided [index].
  /// 
  /// If the index is valid, it removes the result at that index and updates the indices of the remaining results.
  /// If the index is invalid, it prints a message indicating that no result was found at the provided index.
  /// It notifies the listeners.
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

  /// Saves the preferences to persistent storage.
  /// 
  /// It uses the [SharedPreferences] class to store the IP address, authentication token, auto-upload option, and results.
  /// It converts the [_results] list to a JSON string before storing it.
  /// If an error occurs while saving the preferences, it prints an error message in debug mode.
  Future<void> savePreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('ipAddress', _ipAddress);
      prefs.setString('authToken', _authToken);
      prefs.setBool('autoUpload', _autoUpload);
      prefs.setBool('firstTime', _firstTime);
      String resultsJson = jsonEncode(_results);
      prefs.setString('results', resultsJson);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving preferences: $e');
      }
    }
  }

  /// Loads the preferences from persistent storage.
  /// 
  /// It uses the [SharedPreferences] class to retrieve the IP address, authentication token, auto-upload option, and results.
  /// It converts the results JSON string to a list of maps before assigning it to the [_results] property.
  /// If an error occurs while loading the preferences, it prints an error message in debug mode.
  /// It notifies the listeners.
  Future<void> loadPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _ipAddress = prefs.getString('ipAddress') ?? '';
      _authToken = prefs.getString('authToken') ?? '';
      _autoUpload = prefs.getBool('autoUpload') ?? true;
      _firstTime = prefs.getBool('firstTime') ?? true;
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