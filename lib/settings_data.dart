import 'package:flutter/foundation.dart';

class SettingsData extends ChangeNotifier {
  String _ipAddress = '';
  String _authToken = '';
  bool _autoUpload = false;
  List<Map<String, dynamic>> _results = [];

  bool get autoUpload => _autoUpload;
  String get ipAddress => _ipAddress;
  String get authToken => _authToken;
  List<Map<String, dynamic>> get results => _results;

  void updateIpAddress(String newIp) {
    _ipAddress = newIp;
    notifyListeners();
  }

  void updateAuthToken(String newToken) {
    _authToken = newToken;
    notifyListeners();
  }

  void updateAutoUpload(bool value) {
    _autoUpload = value;
    notifyListeners();
  }
  
void addResult(List<dynamic> data) {
  for (var item in data) {
    if (item is Map<String, dynamic>) {
      _results.add(item);
    }
  }
  notifyListeners();
}

  void clearResults() {
    _results.clear();
    notifyListeners();
  }
}