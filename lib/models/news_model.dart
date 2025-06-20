import 'package:Aksara_Literasi/models/source_model.dart';

class News {
  String? id;
  Source? source;
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  String? publishedAt;
  String? content;

  News({
    this.id,
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  factory News.fromNewsApiJson(Map<String, dynamic> json) {
    return News(
      source: json['source'] != null ? Source.fromJson(json['source']) : null,
      author: json['author'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'],
      content: json['content'],
    );
  }

  factory News.fromMyApiJson(Map<String, dynamic> json) {
    return News(
      id: json['id'].toString(),
      author: json['author'],
      title: json['title'],
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'content': content,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
    };
  }
}
