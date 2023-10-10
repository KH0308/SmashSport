import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'connection_class.dart';
import 'colors.dart' as color;
import 'news/news_details.dart';

class News {
  final int id;
  final String eventName;
  final String organizer;
  final int numOfParticipant;
  final String eventImg;

  News({
    required this.id,
    required this.eventName,
    required this.organizer,
    required this.numOfParticipant,
    required this.eventImg,
  });
}

class NewsCarousel extends StatefulWidget {
  final String userID;
  const NewsCarousel({super.key, required this.userID});

  @override
  State<NewsCarousel> createState() => _NewsCarouselState();
}

class _NewsCarouselState extends State<NewsCarousel> {
  List<News> newsList = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    String function = 'allNews';
    var baseUrl = ConnectionClass.ipUrl;
    final response =
        await http.get(Uri.parse('${baseUrl}getNews.php?function=$function'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<News> news = [];

      for (var newsData in data) {
        final nws = News(
          id: newsData['id'],
          eventName: newsData['eventName'],
          organizer: newsData['organizer'],
          numOfParticipant: newsData['numOfParticipant'],
          eventImg: newsData['eventImg'],
        );
        news.add(nws);
      }

      setState(() {
        newsList = news;
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 450,
        viewportFraction: 0.8,
        enlargeCenterPage: true,
      ),
      items: newsList
          .map((item) => NewsCard(item, userID: widget.userID))
          .toList(),
    );
  }
}

class NewsCard extends StatelessWidget {
  final News newsItem;
  final String userID;

  const NewsCard(this.newsItem, {super.key, required this.userID});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color.AppColor.homePageBackground,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: color.AppColor.homePageBackground,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: Image.network(
                  newsItem.eventImg,
                ).image,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0),
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.favorite_rounded,
                      color: color.AppColor.iconWhite,
                      size: 14,
                    ),
                    onPressed: () {
                      print('IconButton pressed ...');
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: color.AppColor.homePageBackground,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EVENTS',
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        color: color.AppColor.gradientTurquoise,
                        fontSize: 12,
                        letterSpacing: 0.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                      child: Text(
                        newsItem.eventName,
                        style: TextStyle(
                          color: color.AppColor.textGreenHard,
                          fontFamily: 'Rubik',
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                      child: Text(
                        newsItem.organizer,
                        style: TextStyle(
                          color: color.AppColor.textGreenHard,
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: color.AppColor.homePageBackground,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: Image.network(
                                      'https://img.freepik.com/free-icon/users-group_318-48680.jpg',
                                    ).image,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
                                child: Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: color.AppColor.gradientTurquoise,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${newsItem.numOfParticipant}++',
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      color: color.AppColor.iconWhite,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              String email = userID;
                              int idNews = newsItem.id;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EventDetailsWidget(
                                    userID: email,
                                    newsFwd: idNews,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: color.AppColor.textBlack,
                              backgroundColor: color.AppColor.gradientTurquoise,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                            ),
                            child: Text(
                              'Join',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 14,
                                color: color.AppColor.textBlack,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
