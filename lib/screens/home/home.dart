import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugasbesar_berita/common/colors.dart';
import 'package:tugasbesar_berita/providers/news_provider.dart';
import 'package:tugasbesar_berita/screens/home/widgets/news_card.dart';
import 'package:tugasbesar_berita/screens/management/management_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsProvider>(context, listen: false).fetchManagedNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 150,
        leading: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Image.asset("assets/images/logo.png", fit: BoxFit.contain),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 28, color: AppColors.black),
            onPressed: () {/* Logika pencarian */},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined,
                size: 28, color: AppColors.black),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ManagementScreen()));
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => Provider.of<NewsProvider>(context, listen: false)
            .fetchManagedNews(),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: Consumer<NewsProvider>(
                builder: (context, newsProvider, child) {
                  if (newsProvider.isManagedLoading &&
                      newsProvider.managedArticles.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final articles = newsProvider.managedArticles;
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
