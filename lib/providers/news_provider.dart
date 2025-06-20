import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tugasbesar_berita/models/news_model.dart';
import 'package:tugasbesar_berita/services/my_api_service.dart';

class NewsProvider extends ChangeNotifier {
  final MyApiService _myApiService = MyApiService();

  List<News> _managedArticles = [];
  List<News> get managedArticles => _managedArticles;
  bool _isManagedLoading = false;
  bool get isManagedLoading => _isManagedLoading;

  Future<void> fetchManagedNews() async {
    _isManagedLoading = true;
    notifyListeners();
    try {
      final response = await _myApiService.getManagedNews();
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _managedArticles = data.map((e) => News.fromMyApiJson(e)).toList();
      }
    } catch (e) {
      showToast("Gagal memuat berita manajemen: $e");
    }
    _isManagedLoading = false;
    notifyListeners();
  }

  Future<bool> addNews(News news) async {
    print('--- Langkah 5: Provider.addNews dipanggil ---');

    print('--- JSON Body yang akan dikirim:');
    print(json.encode(news.toJson()));

    try {
      final response = await _myApiService.createNews(news.toJson());

      print('--- Langkah 6: Respons dari API diterima ---');
      print('   -> Status Code: ${response.statusCode}');
      print('   -> Body: ${response.body}');

      if (response.statusCode == 201) {
        showToast("Berita berhasil ditambahkan");
        fetchManagedNews();
        print('--- Langkah 7: Berhasil, status code 201 ---');
        return true;
      } else {
        showToast("Gagal menambahkan: Status ${response.statusCode}");
        print('--- Langkah 7: Gagal, status code bukan 201 ---');
        return false;
      }
    } catch (e) {
      print('--- Langkah 7: TERJADI ERROR SAAT MENGIRIM REQUEST ---');
      print('   -> Tipe Error: ${e.runtimeType}');
      print('   -> Pesan Error: $e');
      showToast("Error: $e");
      return false;
    }
  }

  Future<bool> updateNews(String id, News news) async {
    try {
      final response = await _myApiService.updateNews(id, news.toJson());

      if (response.statusCode == 200) {
        final updatedNews = News.fromMyApiJson(json.decode(response.body));

        final newsIndex = _managedArticles.indexWhere((item) => item.id == id);

        if (newsIndex >= 0) {
          _managedArticles[newsIndex] = updatedNews;
          notifyListeners();
        }

        showToast("Berita berhasil diperbarui");
        return true;
      } else {
        showToast("Gagal memperbarui: Status ${response.statusCode}");
        return false;
      }
    } catch (e) {
      showToast("Error saat memperbarui: $e");
      return false;
    }
  }

  Future<bool> deleteNews(String id) async {
    try {
      final response = await _myApiService.deleteNews(id);
      if (response.statusCode == 200) {
        showToast("Berita berhasil dihapus");
        _managedArticles.removeWhere((news) => news.id == id);
        notifyListeners();
        return true;
      }
    } catch (e) {/* ... handle error ... */}
    return false;
  }

  void showToast(String message) {
    Fluttertoast.showToast(msg: message);
  }
}
