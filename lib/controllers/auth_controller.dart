// lib/controllers/auth_controller.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:Aksara_Literasi/services/my_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  final MyApiService _apiService = MyApiService();

  Future<bool> login(String email, String password) async {
    try {
      final response = await _apiService.login(email, password);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['body']['success'] == true) {
          final token = data['body']['data']['token'];
          await _saveToken(token);
          _apiService.setToken(token);
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    _apiService.setToken(null);
  }
}
