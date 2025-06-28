import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Aksara_Literasi/models/news_model.dart';
import 'package:Aksara_Literasi/services/my_api_service.dart';

class NewsProvider extends ChangeNotifier {
  final MyApiService _myApiService = MyApiService();

  // BARU: Menyimpan semua artikel asli dari API
  List<News> _allArticles = [];

  // MODIFIKASI: `managedArticles` sekarang menjadi `filteredArticles` untuk menampung hasil filter
  List<News> _filteredArticles = [];
  List<News> get filteredArticles => _filteredArticles;

  bool _isManagedLoading = false;
  bool get isManagedLoading => _isManagedLoading;

  // BARU: State untuk kategori dan pencarian
  String _selectedCategory = 'Semua';
  String get selectedCategory => _selectedCategory;

  String _searchQuery = '';

  void _printDebugInfo(String functionName, dynamic response) {
    print('--- DEBUG INFO: $functionName ---');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    print('-----------------------------------');
  }

  // BARU: Logika untuk memfilter berita
  void _filterNews() {
    List<News> tempArticles = List.from(_allArticles);

    // Filter berdasarkan kategori
    if (_selectedCategory != 'Semua') {
      tempArticles = tempArticles
          .where((article) =>
              article.category?.toLowerCase() ==
              _selectedCategory.toLowerCase())
          .toList();
    }

    // Filter berdasarkan query pencarian
    if (_searchQuery.isNotEmpty) {
      tempArticles = tempArticles
          .where((article) =>
              article.title!.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    _filteredArticles = tempArticles;
    notifyListeners();
  }

  // BARU: Fungsi untuk mengganti kategori terpilih
  void selectCategory(String category) {
    _selectedCategory = category;
    _filterNews(); // Panggil filter setelah kategori diubah
  }

  // BARU: Fungsi untuk melakukan pencarian
  void searchNews(String query) {
    _searchQuery = query;
    _filterNews(); // Panggil filter setelah query pencarian diubah
  }

  Future<void> fetchManagedNews() async {
    _isManagedLoading = true;
    notifyListeners();
    try {
      final response = await _myApiService.getManagedNews();
      _printDebugInfo('fetchManagedNews', response);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = jsonDecode(response.body);
        final Map<String, dynamic> responseBody = responseJson['body'];

        if (responseBody['success'] == true && responseBody['data'] != null) {
          final List<dynamic> data = responseBody['data'];
          // MODIFIKASI: Simpan hasil ke _allArticles
          _allArticles = data.map((e) => News.fromMyApiJson(e)).toList();
          _filterNews(); // Tampilkan semua berita pada awalnya
        } else {
          throw Exception(responseBody['message'] ?? 'Failed to load data');
        }
      } else {
        showToast("Gagal memuat berita: Status ${response.statusCode}");
      }
    } catch (e) {
      showToast("Gagal memuat berita manajemen: $e");
      print('ERROR in fetchManagedNews: $e');
    }
    _isManagedLoading = false;
    notifyListeners();
  }

  // Fungsi add, update, delete tetap sama
  Future<bool> addNews(News news) async {
    try {
      final response = await _myApiService.createNews(news.toJson());
      _printDebugInfo('addNews', response);

      if (response.statusCode == 201 || response.statusCode == 200) {
        showToast("Berita berhasil ditambahkan");
        fetchManagedNews(); // Muat ulang semua berita
        return true;
      } else {
        showToast("Gagal menambahkan: Status ${response.statusCode}");
        return false;
      }
    } catch (e) {
      showToast("Error: $e");
      print('ERROR in addNews: $e');
      return false;
    }
  }

  Future<bool> updateNews(String id, News news) async {
    try {
      final response = await _myApiService.updateNews(id, news.toJson());
      _printDebugInfo('updateNews', response);

      if (response.statusCode == 200) {
        showToast("Berita berhasil diperbarui");
        fetchManagedNews(); // Muat ulang semua berita
        return true;
      } else {
        showToast("Gagal memperbarui: Status ${response.statusCode}");
        return false;
      }
    } catch (e) {
      showToast("Error saat memperbarui: $e");
      print('ERROR in updateNews: $e');
      return false;
    }
  }

  Future<bool> deleteNews(String id) async {
    try {
      final response = await _myApiService.deleteNews(id);
      _printDebugInfo('deleteNews', response);
      if (response.statusCode == 200) {
        showToast("Berita berhasil dihapus");
        fetchManagedNews(); // Muat ulang semua berita
        return true;
      } else {
        showToast("Gagal menghapus: Status ${response.statusCode}");
      }
    } catch (e) {
      showToast("Error saat menghapus: $e");
      print('ERROR in deleteNews: $e');
    }
    return false;
  }

  void showToast(String message) {
    Fluttertoast.showToast(msg: message);
  }
}
