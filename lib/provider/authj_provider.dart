import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  User? _currentUser;

  String? get token => _token;
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _token != null && _currentUser != null;

  void setAuthData({
    required String token,
    required User user,
  }) {
    _token = token;
    _currentUser = user;
    notifyListeners();
  }

  void logout() {
    _token = null;
    _currentUser = null;
    notifyListeners();
  }
}
