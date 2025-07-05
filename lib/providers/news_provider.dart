import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Aksara_Literasi/models/news_model.dart';
import 'package:Aksara_Literasi/services/my_api_service.dart';

class NewsProvider extends ChangeNotifier {
  final MyApiService _myApiService;

  NewsProvider({required MyApiService apiService}) : _myApiService = apiService;

  List<News> _allArticles = [];
  List<News> _filteredArticles = [];
  List<News> get filteredArticles => _filteredArticles;

  bool _isManagedLoading = false;
  bool get isManagedLoading => _isManagedLoading;

  String _selectedCategory = 'Semua';
  String get selectedCategory => _selectedCategory;
  String _searchQuery = '';

  void _printDebugInfo(String functionName, dynamic response) {
    print('--- DEBUG INFO: $functionName ---');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    print('-----------------------------------');
  }

  void _filterNews() {
    List<News> tempArticles = List.from(_allArticles);
    if (_selectedCategory != 'Semua') {
      tempArticles = tempArticles
          .where((article) =>
              article.category?.toLowerCase() ==
              _selectedCategory.toLowerCase())
          .toList();
    }
    if (_searchQuery.isNotEmpty) {
      tempArticles = tempArticles
          .where((article) =>
              article.title!.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    _filteredArticles = tempArticles;
    notifyListeners();
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    _filterNews();
  }

  void searchNews(String query) {
    _searchQuery = query;
    _filterNews();
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
          _allArticles = data.map((e) => News.fromMyApiJson(e)).toList();
          _filterNews();
        } else {
          throw Exception(responseBody['message'] ?? 'Failed to load data');
        }
      } else {
        final errorBody = jsonDecode(response.body);
        showToast("Gagal memuat berita: ${errorBody['message']}");
      }
    } catch (e) {
      showToast("Gagal memuat berita manajemen: $e");
      print('ERROR in fetchManagedNews: $e');
    }
    _isManagedLoading = false;
    notifyListeners();
  }

  Future<bool> addNews(News news) async {
    try {
      final response = await _myApiService.createNews(news.toJson());
      _printDebugInfo('addNews', response);
      if (response.statusCode == 201 || response.statusCode == 200) {
        showToast("Berita berhasil ditambahkan");
        fetchManagedNews();
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
        fetchManagedNews();
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
        fetchManagedNews();
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
