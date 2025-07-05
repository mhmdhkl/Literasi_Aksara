// lib/providers/auth_provider.dart

import 'package:flutter/material.dart';
import 'package:Aksara_Literasi/models/user_model.dart';
import 'package:Aksara_Literasi/services/local_auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final LocalAuthService _localAuthService = LocalAuthService();
  User? _currentUser;
  bool _isLoading = true;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _localAuthService.init(); // Pastikan admin default ada
    await _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();
    _currentUser = await _localAuthService.getCurrentUser();
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();
    final user = await _localAuthService.login(username, password);
    if (user != null) {
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      return true;
    }
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register(String username, String password, String role) async {
    _isLoading = true;
    notifyListeners();
    final user = await _localAuthService.register(username, password, role);
    if (user != null) {
      // Otomatis login setelah register
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      return true;
    }
    _isLoading = false;
    notifyListeners();
    return false; // Gagal karena username sudah ada
  }

  Future<void> logout() async {
    await _localAuthService.logout();
    _currentUser = null;
    notifyListeners();
  }
}
