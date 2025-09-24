import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ziarul_argesul/ads/ad_helper.dart';
import 'package:ziarul_argesul/model/article.dart';
import 'package:ziarul_argesul/pages/category_page.dart';
import 'package:ziarul_argesul/theme/config.dart';
import 'package:ziarul_argesul/widgets/navigation_drawer_widget.dart';
import 'package:ziarul_argesul/widgets/news_card_widget.dart';

import '../services/api_service.dart';
import '../util/url_launcer.dart';

/// The main page of the application which lists the deserialized article models
/// obtained using the News API.

class TimelinePage extends StatefulWidget {
  const TimelinePage({super.key});

  @override
  State<TimelinePage> createState() => _TimelinePage();
}

class _TimelinePage extends State<TimelinePage> {

  late Future<List<Article>> article;
  final String endPointUrl = "https://ziarulargesul.ro";
  late BannerAd bottomBanner;

  @override
  void initState() {
    super.initState();
    article = ApiService().getArticle(endPointUrl);

    bottomBanner = BannerAd(
        size: AdSize.banner,
        adUnitId: AdHelper.bannerAdUnitId,
        listener: BannerAdListener(
            onAdLoaded: (Ad ad) {
              print('Timeline page: Bottom banner loaded');
            },
            onAdFailedToLoad: (Ad ad, LoadAdError error) {
              print('Timeline page: Bottom banner failed to load');
            }
        ),
        request: const AdRequest());

    bottomBanner.load();
  }

  @override
  void dispose() {
    bottomBanner.dispose();
    super.dispose();
  }

  final Uri toLaunch = Uri(scheme: 'https', host: 'www.ziarulargesul.ro');
  final Uri facebookUrltoLaunch = Uri.https('www.facebook.com', 'ZiarulArgesul');

  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: NavigationDrawerWidget(),
    appBar: AppBar(
      elevation: 0.0,
      title: Image.asset('images/argesul_drawer.png',
          height: 41,
          width: 400,
          fit: BoxFit.contain,
          alignment: const Alignment(0.27, 0.27),
      ),
      actions: [
       IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () async {
            await notifications.openNotificationSettings();
          },
       ),
        IconButton(
            icon: Icon(appTheme.currentTheme() == ThemeMode.light
                ? Icons.dark_mode
                : Icons.light_mode),
            onPressed: () {
              appTheme.switchTheme();
              setState(() {});
            },
        ),
      ],
    ),
    body: RefreshIndicator(
      color: Colors.red,
      onRefresh: () async {
        setState(() {
          article = ApiService().getArticle(endPointUrl);
        });
        return Future<void>.delayed(const Duration(seconds: 2));
      },
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Article>>(
              future: article,
              builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
              if (snapshot.hasData) {
                  List<Article>? articles = snapshot.data;
                  return ListView.builder(
                    itemCount: articles?.length,
                    itemBuilder: (context, index) =>
                        newsCard(articles![index], context),
                  );
              }
              else {
                  return const Center(
                      child: CircularProgressIndicator(color: Colors.red,),
                  );
              }
              },
            ),
          ),
          Container(
              height: 75,
              child: AdWidget(ad: bottomBanner)
          ),
      ],
    ),
    ),
    floatingActionButton: SpeedDial(
      backgroundColor: Colors.white,
      visible: true,
      elevation: 8.0,
      shape: const CircleBorder(),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        child: ClipOval(
          child: Image.asset(
            'images/floating_button.png', // Replace with your image path
            width: 68, // Adjust width as needed
            height: 68, // Adjust height as needed
            fit: BoxFit.cover, // Adjust how the image fits inside the circular shape
          ),
        ),
      ),
      children: [
        SpeedDialChild(
          child: const Icon(Icons.phone),
          backgroundColor: Colors.green,
          onTap: () => openDialer('0737035999'),
          label: 'Contacteaza-ne telefonic',
          labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
        ),
        SpeedDialChild(
            child: const Icon(Icons.facebook_sharp),
            backgroundColor: Colors.blueAccent,
            onTap: () {
              _launchInBrowser(facebookUrltoLaunch);
            },
          label: 'Pagina noastra de Facebook',
          labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
        ),
        SpeedDialChild(
          child: const Icon(Icons.http_sharp),
          backgroundColor: Colors.indigoAccent,
          onTap: () {
            _launchInBrowser(toLaunch);
          },
          label: 'Site Ziarul Argesul',
          labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
        )
      ],
    ),
  );

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
}

class MySearchDelegate extends SearchDelegate{
  List<String> searchTerms = [
    "Stiri Arges",
    "Stiri Pitesti",
    "Administrativ",
    "Editorial",
    "Sport",
    "Anunturi",
    "Termeni si conditii"
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var v in searchTerms) {
      if (v.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(v);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var v in searchTerms) {
      if (v.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(v);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          onTap:  () {
            close(context, result);
            Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Category("")),
          );},
          title: Text(result),
        );
      },
    );
  }
}