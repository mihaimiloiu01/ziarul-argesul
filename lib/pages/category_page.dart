import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ziarul_argesul/pages/timeline_page.dart';

import '../ads/ad_helper.dart';
import '../model/article.dart';
import '../services/api_service.dart';
import '../util/transitions.dart';
import '../widgets/news_card_widget.dart';

class Category extends StatefulWidget {
  final String title;
  const Category(this.title, {Key? key}) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  late List<Article> articles = [];
  final String rootEndPointUrl = "https://ziarulargesul.ro/";
  late BannerAd bottomBanner;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadArticles();

    bottomBanner = BannerAd(
      size: AdSize.banner,
      adUnitId: AdHelper.bannerAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('News Category page: Bottom banner loaded');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('News Category page: Bottom banner failed to load');
        },
      ),
      request: const AdRequest(),
    );

    bottomBanner.load();
  }

  Future<void> _loadArticles() async {
    List<String> listOfUrls = await ApiService().getNewsList("${rootEndPointUrl}category/${getCategory(widget.title)}");
    for (String url in listOfUrls) {
      List<Article> currentArticle = await ApiService().getArticle(url);
      if (currentArticle.isNotEmpty) {
        setState(() {
          articles.add(currentArticle[0]);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      elevation: 0.0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).push(
          SlideRightRoute(page: const TimelinePage()),
        ),
      ),
      title: Text(widget.title),
      centerTitle: true,
    ),
    body: Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            color: Colors.red,
            onRefresh: () async {
              articles.clear();
              await _loadArticles();
            },
            child: ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) => newsCard(articles[index], context),
            ),
          ),
        ),
        Container(
          height: 75,
          child: AdWidget(ad: bottomBanner),
        ),
      ],
    ),
  );

  String getCategory(String title) {
    switch (title) {
      case "Stiri Arges":
        return "stiri-pitesti-arges";
      case "Stiri Pitesti":
        return "stiri-pitesti-online";
      case "Administrativ":
        return "administratie-pitesti-arges";
      case "Editorial":
        return "editoriale";
      case "Sport":
        return "sport-pitesti-arges";
      case "Anunturi":
        return "anunturi";
      default:
        return "";
    }
  }
}
