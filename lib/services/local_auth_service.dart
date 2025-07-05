// lib/services/local_auth_service.dart

import 'dart:convert';
import 'package:flutter/material.dart'; // Untuk debugPrint
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Aksara_Literasi/models/user_model.dart';

class LocalAuthService {
  static const _usersKey = 'users';
  static const _currentUserKey = 'currentUser';

  // Inisialisasi dengan akun admin default jika belum ada
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final existingUsers = prefs.getStringList(_usersKey);
    debugPrint(
        "[AuthService] Init: Memeriksa pengguna. Apakah sudah ada? ${existingUsers != null}");

    if (existingUsers == null) {
      debugPrint(
          "[AuthService] Init: Belum ada daftar pengguna. Membuat admin default.");
      final adminUser =
          User(username: 'admin', password: 'password', role: 'admin');
      await _saveUsers([adminUser]);
    } else {
      debugPrint(
          "[AuthService] Init: Daftar pengguna sudah ada. Jumlah: ${existingUsers.length}");
    }
  }

  Future<List<User>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList(_usersKey) ?? [];
    debugPrint(
        "[AuthService] _getUsers: Mengambil ${usersJson.length} pengguna dari SharedPreferences.");
    return usersJson.map((json) => User.fromJson(json)).toList();
  }

  Future<void> _saveUsers(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = users.map((user) => user.toJson()).toList();
    await prefs.setStringList(_usersKey, usersJson);
    debugPrint(
        "[AuthService] _saveUsers: Menyimpan ${users.length} pengguna ke SharedPreferences.");
  }

  Future<User?> register(String username, String password, String role) async {
    debugPrint("[AuthService] Register: Mencoba mendaftarkan '$username'");
    final users = await _getUsers();
    if (users.any((user) => user.username == username)) {
      debugPrint(
          "[AuthService] Register: Gagal, username '$username' sudah ada.");
      return null; // Username sudah ada
    }
    final newUser = User(username: username, password: password, role: role);
    users.add(newUser);
    await _saveUsers(users); // Menyimpan daftar yang sudah diperbarui
    debugPrint("[AuthService] Register: Berhasil mendaftarkan '$username'.");
    return newUser;
  }

  Future<User?> login(String username, String password) async {
    final users = await _getUsers();
    debugPrint(
        "[AuthService] Login: Mencoba login dengan username '$username'. Total pengguna tersimpan: ${users.length}");
    try {
      final user = users.firstWhere(
        (user) => user.username == username && user.password == password,
      );
      await _setCurrentUser(user);
      debugPrint(
          "[AuthService] Login: Berhasil untuk '$username'. Role: ${user.role}");
      return user;
    } catch (e) {
      debugPrint("[AuthService] Login: Gagal untuk '$username'. Error: $e");
      return null; // Login gagal
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
    debugPrint("[AuthService] Logout: Pengguna saat ini telah dihapus.");
  }

  Future<void> _setCurrentUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, user.toJson());
  }

  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_currentUserKey);
    if (userJson != null) {
      debugPrint("[AuthService] getCurrentUser: Pengguna ditemukan di sesi.");
      return User.fromJson(userJson);
    }
    debugPrint("[AuthService] getCurrentUser: Tidak ada pengguna di sesi.");
    return null;
  }
}
