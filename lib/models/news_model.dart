import 'package:Aksara_Literasi/models/source_model.dart';

class News {
  String? id;
  String? author;
  String? title;
  String? summary;
  String? url;
  String? featuredImageUrl;
  String? publishedAt;
  String? content;
  List<String>? tags;
  bool? isPublished;
  String? category;

  News({
    this.id,
    this.author,
    this.title,
    this.summary,
    this.url,
    this.featuredImageUrl,
    this.publishedAt,
    this.content,
    this.tags,
    this.isPublished,
    this.category,
  });

  factory News.fromNewsApiJson(Map<String, dynamic> json) {
    return News(
      author: json['author'],
      title: json['title'],
      summary: json['description'],
      url: json['url'],
      featuredImageUrl: json['urlToImage'],
      publishedAt: json['publishedAt'],
      content: json['content'],
    );
  }

  factory News.fromMyApiJson(Map<String, dynamic> json) {
    return News(
      id: json['id']?.toString(),
      author:
          json['author'] != null ? json['author']['name'] : 'Unknown Author',
      title: json['title'],
      featuredImageUrl: json['featured_image_url'],
      publishedAt: json['updated_at'] ?? json['created_at'],
      content: json['content'],
      summary: json['summary'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      isPublished: json['is_published'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'title': title,
      'content': content,
      'summary': summary,
      'featuredImageUrl': featuredImageUrl,
      'tags': tags ?? [],
      'isPublished': isPublished ?? true,
      'category': category ?? 'General',
    };

    data.removeWhere(
        (key, value) => value == null && key != 'title' && key != 'content');

    return data;
  }
}
