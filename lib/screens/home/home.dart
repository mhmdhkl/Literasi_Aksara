import 'package:flutter/material.dart';
import 'package:tugasbesar_berita/common/colors.dart';
import 'package:tugasbesar_berita/screens/home/widgets/CategoryItem.dart';

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
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Placeholder for news list
          ],
        ),
      ),
    );
  }
}
