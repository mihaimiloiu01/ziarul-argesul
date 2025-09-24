import 'dart:convert';

import 'package:html_unescape/html_unescape.dart';
import 'package:html/parser.dart';

class Utils {

  static String replaceHtmlEntities(String? input) {
    var htmlUnescape = HtmlUnescape();
    String replacedText = htmlUnescape.convert(input!);
    return replacedText;
  }

  /// Method used to:
  /// Find all <script> tags with type="application/ld+json"
  /// Extract the JSON content from the first <script> tag found
  /// Decode the JSON data
  ///
  /// It returns the html info retrieved by GET endpoint in form of a JSONDataMap
  ///
  static Future<Map<String, dynamic>> extractJsonFromHtml(String htmlContent) async {
    final document = parse(htmlContent);
    var scriptElements = document.querySelectorAll('script[type="application/ld+json"]');
    String jsonData = scriptElements.isNotEmpty ? scriptElements[0].text : '';
    Map<String, dynamic> jsonDataMap = json.decode(jsonData);

    return jsonDataMap;
  }

 static List<String> extractUrlsFromJson(Map<String, dynamic> jsonData) {

    List<String> urls = [];

    try {
      List<dynamic> itemListElement = jsonData['@graph'][0]['itemListElement'];

      for (var item in itemListElement) {
        String url = item['url'];
        urls.add(url);
      }
    } catch (e) {
      print('Error parsing JSON: $e');
    }
    return urls;
  }
}