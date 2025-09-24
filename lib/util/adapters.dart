import 'package:hive/hive.dart';

import '../model/article.dart';

class ArticleAdapter extends TypeAdapter<Article> {
  @override
  final int typeId = 0;

  @override
  Article read(BinaryReader reader) {
    return Article(
      name: reader.read(),
      description: reader.read(),
      url: reader.read(),
      urlToImage: reader.read(),
      datePublished: reader.read(),
      articleBody: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Article obj) {
    writer.write(obj.name);
    writer.write(obj.description);
    writer.write(obj.url);
    writer.write(obj.urlToImage);
    writer.write(obj.datePublished);
    writer.write(obj.articleBody);
  }
}