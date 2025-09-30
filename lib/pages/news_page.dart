import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ziarul_argesul/util/utils.dart';

import '../ads/ad_helper.dart';

class ArticleDetailsScreen extends StatefulWidget {
  String? title, urlToImage, author, publishedAt, description, content, url;
  ArticleDetailsScreen(
      {super.key,
        this.title,
        this.urlToImage,
        this.author,
        this.publishedAt,
        this.description,
        this.content,
        this.url});

  @override
  State<ArticleDetailsScreen> createState() => _ArticleDetailsScreenState();
}

class _ArticleDetailsScreenState extends State<ArticleDetailsScreen> {
  BannerAd? bottomBanner;
  bool isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _createBannerAd();
  }

  void _createBannerAd() {
    bottomBanner = BannerAd(
      size: AdSize.banner,
      adUnitId: AdHelper.bannerAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('✅ Banner ad loaded successfully');
          setState(() {
            isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('❌ Banner ad failed to load: ${error.message}');
          print('Error code: ${error.code}');
          print('Error domain: ${error.domain}');
          ad.dispose();
          setState(() {
            isAdLoaded = false;
            bottomBanner = null;
          });
        },
        onAdOpened: (Ad ad) => print('Banner ad opened'),
        onAdClosed: (Ad ad) => print('Banner ad closed'),
      ),
      request: const AdRequest(),
    );

    bottomBanner?.load();
  }

  void _shareArticle() {
    final String shareText = '${Utils.replaceHtmlEntities(widget.title ?? "Articol")}\n\n${widget.url ?? ""}';

    Share.share(
      shareText,
      subject: Utils.replaceHtmlEntities(widget.title ?? "Articol de la Ziarul Argesul"),
    );
  }

  @override
  void dispose() {
    bottomBanner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Image.asset(
          'images/argesul_drawer.png',
          height: 41,
          fit: BoxFit.contain,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareArticle,
            tooltip: 'Distribuie articolul',
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: <Widget>[
                Stack(
                  children: [
                    Image.network(
                      widget.urlToImage!,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.5,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 350.0, 0.0, 100.0),
                      child: Material(
                        type: MaterialType.canvas,
                        borderRadius: BorderRadius.circular(40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                              child: Text(
                                Utils.replaceHtmlEntities(widget.title!),
                                style: const TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Chip(
                              backgroundColor: Colors.grey.withOpacity(0.1),
                              label: Text(
                                DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.publishedAt!)),
                                style: const TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: Text(
                                Utils.replaceHtmlEntities(widget.description!),
                                style: const TextStyle(
                                  fontSize: 25.0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: Text(
                                Utils.replaceHtmlEntities(widget.content!),
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Card(
                              clipBehavior: Clip.antiAlias,
                              margin: const EdgeInsets.all(16),
                              elevation: 20,
                              color: Colors.black12,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(35)),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  InkWell(
                                    child: ColorFiltered(
                                      colorFilter: ColorFilter.mode(
                                          Colors.black12.withOpacity(0.8),
                                          BlendMode.srcOver),
                                      child: Image.network(
                                        widget.urlToImage!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    onTap: () async {
                                      await launchUrlString(widget.url!);
                                    },
                                  ),
                                  const Text(
                                    "Continua catre sursa",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 24),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          if (isAdLoaded && bottomBanner != null)
            Container(
              height: 60,
              child: AdWidget(ad: bottomBanner!),
            ),
          if (!isAdLoaded)
            Container(
              height: 60,
              color: Colors.grey[200],
              child: const Center(
                child: Text('Loading ad...', style: TextStyle(color: Colors.grey)),
              ),
            ),
        ],
      ),
    );
  }
}