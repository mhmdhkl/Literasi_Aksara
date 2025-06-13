import 'package:flutter/material.dart';
import 'package:tugasbesar_berita/common/colors.dart';
import 'package:tugasbesar_berita/common/common.dart';
import 'package:tugasbesar_berita/common/widgets/no_connectivity.dart';
import 'package:tugasbesar_berita/models/listdata_model.dart';
import 'package:tugasbesar_berita/models/news_model.dart' as m;
import 'package:tugasbesar_berita/providers/news_provider.dart';
import 'package:tugasbesar_berita/screens/home/widgets/CategoryItem.dart';
import 'package:tugasbesar_berita/screens/home/widgets/newsCard.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> categories = [
    'business',
    'entertainment',
    'general',
    'health',
    'science',
    'sports',
    'technology',
  ];

  int activeCategory = 0;
  int page = 1;
  List<m.News> articles = [];

  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    if (await getInternetStatus()) {
      getNewsData();
    } else {
      Navigator.of(context, rootNavigator: true)
          .push(MaterialPageRoute(builder: (context) => const NoConnectivity()))
          .then((value) => checkConnectivity());
    }
  }

  Future<void> getNewsData() async {
    ListData listData = await NewsProvider().GetEverything(
      categories[activeCategory].toString(),
      page++,
    );
    if (listData.status) {
      List<m.News> items = listData.data as List<m.News>;
      if (items.isNotEmpty) {
        articles.addAll(items);
        if (mounted) setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        leading: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Image.asset(
              "assets/images/logo.png",
              fit: BoxFit.contain,
              color: AppColors.white,
            ),
          ),
        ),
        backgroundColor: AppColors.black,
        elevation: 5,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.search, size: 34, color: AppColors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              width: size.width,
              child: ListView.builder(
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) => CategoryItem(
                  index: index,
                  categoryName: categories[index],
                  activeCategory: activeCategory,
                  onClick: () {
                    setState(() {
                      activeCategory = index;
                      articles = [];
                      page = 1;
                    });
                    getNewsData();
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: size.height * 0.75,
              child: ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) =>
                    NewsCard(article: articles[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
