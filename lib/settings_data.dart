import 'package:flutter/foundation.dart';

class SettingsData extends ChangeNotifier {
  String _ipAddress = '';
  String _authToken = '';

  String get ipAddress => _ipAddress;
  String get authToken => _authToken;

  void updateIpAddress(String newIp) {
    _ipAddress = newIp;
    notifyListeners();
  }

  void updateAuthToken(String newToken) {
    _authToken = newToken;
    notifyListeners();
  }
}