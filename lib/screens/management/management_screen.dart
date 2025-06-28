import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Aksara_Literasi/common/colors.dart';
import 'package:Aksara_Literasi/providers/news_provider.dart';
import 'package:Aksara_Literasi/screens/add_edit_news_screen.dart';

class ManagementScreen extends StatefulWidget {
  const ManagementScreen({super.key});

  @override
  State<ManagementScreen> createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  @override
  void initState() {
    super.initState();
    // Data sudah di-fetch di halaman Home, kita tidak perlu fetch ulang
    // kecuali jika ingin memastikan data selalu terbaru saat masuk halaman ini.
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<NewsProvider>(context, listen: false).fetchManagedNews();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Berita',
            style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
          // MODIFIKASI: Gunakan filteredArticles
          if (newsProvider.isManagedLoading &&
              newsProvider.filteredArticles.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () => newsProvider.fetchManagedNews(),
            child: ListView.builder(
              // MODIFIKASI: Gunakan filteredArticles
              itemCount: newsProvider.filteredArticles.length,
              itemBuilder: (context, index) {
                // MODIFIKASI: Gunakan filteredArticles
                final news = newsProvider.filteredArticles[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: ListTile(
                    leading: const Icon(Icons.article_outlined),
                    title: Text(news.title ?? 'No Title'),
                    subtitle: Text(news.author ?? 'No Author'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.edit, color: Colors.blueAccent),
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                              builder: (_) => AddEditNewsScreen(news: news),
                            ))
                                .then((_) {
                              // Muat ulang data setelah kembali dari halaman edit, jika diperlukan
                              newsProvider.fetchManagedNews();
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.redAccent),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Konfirmasi Hapus'),
                                content: const Text(
                                    'Anda yakin ingin menghapus berita ini?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Batal'),
                                    onPressed: () => Navigator.of(ctx).pop(),
                                  ),
                                  TextButton(
                                    child: const Text('Hapus'),
                                    onPressed: () {
                                      if (news.id != null) {
                                        Provider.of<NewsProvider>(context,
                                                listen: false)
                                            .deleteNews(news.id!);
                                      }
                                      Navigator.of(ctx).pop();
                                    },
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
            builder: (_) => const AddEditNewsScreen(),
          ))
              .then((_) {
            // Muat ulang data setelah kembali dari halaman tambah, jika diperlukan
            Provider.of<NewsProvider>(context, listen: false)
                .fetchManagedNews();
          });
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
