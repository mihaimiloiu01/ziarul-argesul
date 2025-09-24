import 'package:hive_flutter/adapters.dart';

/// This class represents the deserialized model of an article.
/// After the information is retrieved from the server, the article models are
/// loaded with relevant information offered by the news API.
@HiveType(typeId: 0)
class Article {
  /// Fields corresponding to the data of an article retrieved by the news API.
  @HiveField(1)
  String name;

  String description;
  String url;
  String urlToImage;

  @HiveField(2)
  String datePublished;

  String articleBody;

  /// Article model constructor.
  Article({
        required this.name,
        required this.url,
        required this.urlToImage,
        required this.datePublished,
        required this.description,
        required this.articleBody
      });

  /// Building an article model using the deserialized information.
  factory Article.fromJson(Map<String, dynamic> json) {
    /// Mapping the deserialized info into article object with null checks for components.

    Map<String, String> defaults = {
      "thumbnailUrl": "https://ziarulargesul.ro/wp-content/uploads/2022/08/Ziarul-Argesul-Logo.png",
      "name": "NAME",
      "datePublished": "DATE_PUBLISHED",
      "url": "URL",
      "description": "DESCRIPTION",
      "articleBody": "ARTICLE_BODY",
    };

    return Article(
        description: json["description"] ?? defaults["description"],
        name: json["name"] ?? defaults["name"],
        url: json["url"] ?? defaults["url"],
        urlToImage: json["thumbnailUrl"] ?? defaults["thumbnailUrl"],
        datePublished: json["datePublished"] ?? defaults["datePublished"],
        articleBody: json["articleBody"] ?? defaults["articleBody"]
    );
  }

}