import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Aksara_Literasi/common/colors.dart';
import 'package:Aksara_Literasi/providers/news_provider.dart';
import 'package:Aksara_Literasi/screens/home/widgets/news_card.dart';
import 'package:Aksara_Literasi/screens/management/management_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  // MODIFIKASI: Menggunakan Map untuk kategori, termasuk 'Semua'
  final Map<String, String> _categories = {
    'Semua': 'Semua',
    'Business': 'Bisnis',
    'Technology': 'Teknologi',
    'Health': 'Kesehatan',
    'Sports': 'Olahraga',
    'General': 'Umum'
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsProvider>(context, listen: false).fetchManagedNews();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Cari berita...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white70),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) {
        Provider.of<NewsProvider>(context, listen: false).searchNews(query);
      },
    );
  }

  Widget _buildCategoryChips() {
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              // MODIFIKASI: Ambil key dan value dari Map
              final categoryKey = _categories.keys.elementAt(index);
              final categoryValue = _categories.values.elementAt(index);
              final bool isSelected =
                  newsProvider.selectedCategory == categoryKey;

              return Padding(
                padding: EdgeInsets.only(
                    left: index == 0 ? 16.0 : 8.0,
                    right: index == _categories.length - 1 ? 16.0 : 0),
                child: ChoiceChip(
                  label: Text(categoryValue), // Tampilkan nilai Indonesia
                  selected: isSelected,
                  checkmarkColor: Colors.white,
                  onSelected: (selected) {
                    if (selected) {
                      // Kirim nilai English ke provider untuk filtering
                      newsProvider.selectCategory(categoryKey);
                    }
                  },
                  backgroundColor: Colors.grey[200],
                  selectedColor: AppColors.black,
                  labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? _buildSearchField()
            : Image.asset("assets/images/logo.png",
                fit: BoxFit.contain, height: 32),
        backgroundColor: _isSearching ? AppColors.black : Colors.white,
        iconTheme:
            IconThemeData(color: _isSearching ? Colors.white : AppColors.black),
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  Provider.of<NewsProvider>(context, listen: false)
                      .searchNews('');
                }
              });
            },
          ),
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ManagementScreen()));
              },
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => Provider.of<NewsProvider>(context, listen: false)
            .fetchManagedNews(),
        child: Column(
          children: [
            _buildCategoryChips(),
            const Divider(height: 1),
            Expanded(
              child: Consumer<NewsProvider>(
                builder: (context, newsProvider, child) {
                  if (newsProvider.isManagedLoading &&
                      newsProvider.filteredArticles.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final articles = newsProvider.filteredArticles;

                  if (articles.isEmpty) {
                    return const Center(
                        child: Text("Tidak ada berita yang ditemukan."));
                  }

                  return ListView.builder(
                    itemCount: articles.length,
                    itemBuilder: (context, index) =>
                        NewsCard(article: articles[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
