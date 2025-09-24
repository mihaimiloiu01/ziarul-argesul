import 'package:http/http.dart';
import '../model/article.dart';
import '../util/utils.dart';

/// API Service class is our endpoint which assures the connection between the
/// timeline page and all the news provided by the News API.
class ApiService {

  Future<List<Article>> getArticle(String endPointUrl) async {
    Response res = await get(Uri.parse(endPointUrl));

    String desiredType = "BlogPosting";
    List<dynamic> filteredDataList = [];

    if (res.statusCode == 200) {
      Map<String, dynamic> json1 = await Utils.extractJsonFromHtml(res.body);
      filteredDataList = json1["@graph"]
          .where((jsonObject) => jsonObject["@type"] == desiredType)
          .toList();

      List<Article> articles = await mapJSONContentToArticle(filteredDataList);
      return articles;
    } else {
      throw ("Can't get the Articles");
    }
  }

  Future<List<String>> getNewsList(String endpointUrl) async {

    Response res = await get(Uri.parse(endpointUrl));

    if (res.statusCode == 200) {
      Map<String, dynamic> json = await Utils.extractJsonFromHtml(res.body);
      return Utils.extractUrlsFromJson(json);
    } else {
      throw ("Can't get the urls");
    }
  }

  Future<List<Article>> mapJSONContentToArticle(List<dynamic> deserialisedInfo) async {

    List<Article> articles = deserialisedInfo
        .map((dynamic item) => Article.fromJson(item)).toList();
    return articles;
  }
}