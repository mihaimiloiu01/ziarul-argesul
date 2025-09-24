import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:ziarul_argesul/model/article.dart';
import 'package:ziarul_argesul/util/utils.dart';

import '../ads/ad_helper.dart';
import '../pages/news_page.dart';
import '../util/transitions.dart';

Widget newsCard(Article article, BuildContext context) {

  // Uncomment when deciding to introduce interstitial ads when opening news
  //void loadAndShowArticleInterstitialAd() {
  //  InterstitialAd.load(
  //      adUnitId: AdHelper.articleInterstitialAdUnitId,
  //      request: const AdRequest(),
  //      adLoadCallback: InterstitialAdLoadCallback(
  //        onAdLoaded: (ad) {
  //          debugPrint('Timeline page: Interstitial ad loaded');
  //          ad.show();
  //        },
  //        onAdFailedToLoad: (LoadAdError error) {
  //          debugPrint('Timeline page: Interstitial ad failed to load: $error');
  //        },
  //      )
  //  );
  //}

  return GestureDetector(
      onTap: () {
        // Uncomment when deciding to introduce interstitial ads when opening news
        //loadAndShowArticleInterstitialAd();

        Navigator.push(
            context,
            SlideLeftRoute(
                page: ArticleDetailsScreen(
                  urlToImage: article.urlToImage,
                  title: article.name,
                  publishedAt: article.datePublished,
                  description: article.description,
                  content: article.articleBody,
                  url: article.url
                )
            )
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  article.urlToImage,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 0.38,
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.80 * 0.5, // Half the height of the image
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black87.withOpacity(0.99),
                        ],
                        stops: const [0.2, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 40,
                left: 20,
                right: 20,
                child: AutoSizeText(
                  Utils.replaceHtmlEntities(article.name),
                  style: TextStyle(color: Colors.white.withOpacity(1.0), fontSize: 20, fontWeight: FontWeight.bold),
                  maxLines: 2,
                ),
              ),
              Positioned(
                left: 20,
                bottom: 8,
                child: AutoSizeText(
                  DateFormat('dd-MM-yyyy').format(DateTime.parse(article.datePublished)),
                  style: TextStyle(color: Colors.white.withOpacity(1.0), fontSize: 13),
                ),
              )
            ],
          ),
        )
      ),
  );
}