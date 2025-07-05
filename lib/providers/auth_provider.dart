// lib/providers/auth_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Aksara_Literasi/services/my_api_service.dart';
import 'dart:convert';

class AuthProvider extends ChangeNotifier {
  final MyApiService apiService;
  String? _token;
  bool _isLoading = true;

  String? get token => _token;
  bool get isLoading => _isLoading;

  AuthProvider({required this.apiService}) {
    _loadTokenFromStorage();
  }

  Future<void> _loadTokenFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('jwt_token');
    if (storedToken != null) {
      _token = storedToken;
      apiService.setToken(_token);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await apiService.login(email, password);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['body']['success'] == true) {
          _token = data['body']['data']['token'];
          apiService.setToken(_token);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', _token!);
          _isLoading = false;
          notifyListeners();
          return true;
        }
      }
    } catch (e) {
      debugPrint('Login failed: $e');
    }
    _isLoading = false;
    notifyListeners();
    return false;
  }
}
