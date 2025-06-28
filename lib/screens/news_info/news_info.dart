import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:Aksara_Literasi/common/colors.dart';
import 'package:Aksara_Literasi/models/news_model.dart';
import 'package:Aksara_Literasi/providers/news_provider.dart';
import 'package:Aksara_Literasi/screens/add_edit_news_screen.dart';

class NewsInfo extends StatelessWidget {
  final News news;

  const NewsInfo({super.key, required this.news});

  void _deleteNews(BuildContext context) async {
    if (news.id == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Berita?'),
        content: const Text('Apakah Anda yakin ingin menghapus berita ini?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal')),
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Hapus')),
        ],
      ),
    );

    if (confirmed == true) {
      final newsProvider = Provider.of<NewsProvider>(context, listen: false);
      final success = await newsProvider.deleteNews(news.id!);
      if (success && context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // const String corsProxy = "https://corsproxy.io/?"; // Kita coba nonaktifkan proxy

    // URL gambar yang akan di-debug
    final imageUrl = news.featuredImageUrl;

    // Mencetak URL ke debug console untuk diagnosis
    if (imageUrl != null && imageUrl.isNotEmpty) {
      print("NewsInfo trying to load image: $imageUrl");
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_sharp, color: AppColors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.white),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => AddEditNewsScreen(news: news),
              ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: AppColors.white),
            onPressed: () => _deleteNews(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            if (imageUrl != null && imageUrl.isNotEmpty)
              Image.network(
                // Menggunakan URL langsung tanpa proxy
                imageUrl,
                fit: BoxFit.contain,
                width: size.width,
                errorBuilder: (context, error, stackTrace) {
                  // Jika error, kita cetak juga errornya untuk info tambahan
                  print("Image load error: $error");
                  return Container(
                    height: 220,
                    width: size.width,
                    color: Colors.grey[200],
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.broken_image, color: Colors.grey, size: 50),
                        SizedBox(height: 8),
                        Text('Gagal memuat gambar',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  );
                },
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title ?? 'Tanpa Judul',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Icon(Icons.person,
                          color: AppColors.black, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          news.author ?? 'Tanpa Penulis',
                          style: GoogleFonts.poppins(color: AppColors.black),
                        ),
                      ),
                    ],
                  ),
                  if (news.summary != null && news.summary!.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      news.summary!,
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[700]),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Text(
                    news.content ?? 'Konten tidak tersedia.',
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
