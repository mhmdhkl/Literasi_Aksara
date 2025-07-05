// lib/main.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Aksara_Literasi/providers/auth_provider.dart';
import 'package:Aksara_Literasi/providers/news_provider.dart';
import 'package:Aksara_Literasi/screens/auth/auth_wrapper.dart';
import 'package:Aksara_Literasi/services/my_api_service.dart';

Future<void> main() async {
  // 1. Pastikan binding Flutter sudah siap
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Buat instance MyApiService
  final myApiService = MyApiService();

  // 3. Lakukan login akun layanan di latar belakang untuk mendapatkan token API
  try {
    final response = await myApiService.login("news@itg.ac.id", "ITG#news");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['body']['success'] == true) {
        final token = data['body']['data']['token'];
        // 4. Set token ke instance MyApiService agar bisa digunakan untuk semua request berita
        myApiService.setToken(token);
        debugPrint("Login akun layanan BERHASIL. Token API telah diatur.");
      } else {
        debugPrint("Login akun layanan GAGAL: ${data['body']['message']}");
      }
    } else {
      debugPrint(
          "Login akun layanan GAGAL dengan status code: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");
    }
  } catch (e) {
    debugPrint("Error saat login akun layanan: $e");
  }

  // 5. Jalankan aplikasi dengan provider yang sudah siap
  runApp(MyApp(myApiService: myApiService));
}

class MyApp extends StatelessWidget {
  final MyApiService myApiService;
  const MyApp({super.key, required this.myApiService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provider untuk otentikasi pengguna lokal (admin/pembaca)
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),

        // Provider berita yang menggunakan MyApiService yang sudah memiliki token
        ChangeNotifierProvider<NewsProvider>(
          create: (_) => NewsProvider(apiService: myApiService),
        ),
      ],
      child: MaterialApp(
        title: 'News App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}
