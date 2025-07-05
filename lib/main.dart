// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:Aksara_Literasi/providers/auth_provider.dart';
import 'package:Aksara_Literasi/providers/news_provider.dart';
import 'package:Aksara_Literasi/services/my_api_service.dart';
import 'package:Aksara_Literasi/screens/welcome.dart';

Future main() async {
  await dotenv.load(fileName: "assets/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Menyediakan instance MyApiService
        Provider<MyApiService>(create: (_) => MyApiService()),

        // AuthProvider bergantung pada MyApiService
        ChangeNotifierProxyProvider<MyApiService, AuthProvider>(
          create: (context) => AuthProvider(
            apiService: Provider.of<MyApiService>(context, listen: false),
          ),
          update: (context, apiService, previous) =>
              previous ?? AuthProvider(apiService: apiService),
        ),

        // NewsProvider bergantung pada MyApiService dan AuthProvider
        ChangeNotifierProxyProvider<AuthProvider, NewsProvider>(
          create: (context) => NewsProvider(
            apiService: Provider.of<MyApiService>(context, listen: false),
          ),
          update: (context, auth, previous) {
            // Set token di MyApiService setiap kali auth berubah
            final apiService =
                Provider.of<MyApiService>(context, listen: false);
            final token = auth.token;
            apiService.setToken(token);
            return previous ?? NewsProvider(apiService: apiService);
          },
        ),
      ],
      child: MaterialApp(
        title: 'News App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Welcome(),
      ),
    );
  }
}
