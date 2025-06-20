import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:tugasbesar_berita/common/colors.dart';
import 'package:tugasbesar_berita/models/news_model.dart';
import 'package:tugasbesar_berita/screens/news_info/news_info.dart';

class NewsCard extends StatelessWidget {
  final News article;
  const NewsCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    // GANTI DENGAN PROXY BARU YANG LEBIH STABIL
    const String corsProxy = "https://corsproxy.io/?";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewsInfo(news: article)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Card(
          elevation: 4,
          shadowColor: Colors.black26,
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (article.urlToImage != null && article.urlToImage!.isNotEmpty)
                Image.network(
                  // Menggunakan proxy baru
                  corsProxy + Uri.encodeComponent(article.urlToImage!),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image,
                              color: Colors.grey, size: 50),
                          SizedBox(height: 8),
                          Text(
                            'Gagal memuat gambar',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ... (sisa kode tidak berubah)
                    Text(
                      article.title ?? 'No Title',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(Icons.person_outline,
                                  size: 16, color: AppColors.lightGray),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  article.author ?? 'Unknown Author',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                      color: AppColors.lightGray, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                size: 16, color: AppColors.lightGray),
                            const SizedBox(width: 4),
                            Text(
                              Jiffy.parse(article.publishedAt ??
                                      DateTime.now().toIso8601String())
                                  .fromNow(),
                              style: GoogleFonts.poppins(
                                  color: AppColors.lightGray, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article.content ?? 'No content available.',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: AppColors.lighterBlack,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
