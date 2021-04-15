import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:news_app/controllers/favorite_controller.dart';
import 'package:news_app/models/news_model.dart';

class DetailPage extends StatelessWidget {
  final NewsModel news;
  DetailPage({Key key, @required this.news}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(news.urlToImage);
    return Scaffold(
      appBar: AppBar(
        title: Text("Подробнее"),
        actions: [
          GetBuilder<FavoriteController>(
            builder: (favoriteController) => favoriteController.favorites.value
                    .where((element) =>
                        element.publishedAt.microsecondsSinceEpoch ==
                        news.publishedAt.microsecondsSinceEpoch)
                    .isEmpty
                ? IconButton(
                    icon: Icon(Icons.bookmark_border),
                    onPressed: () {
                      favoriteController.addFavorite(news);
                    },
                  )
                : IconButton(
                    color: Get.theme.accentColor,
                    icon: Icon(Icons.bookmark),
                    onPressed: () {
                      favoriteController.removeFromFavorite(news);
                    },
                  ),
          )
        ],
      ),
      body: Card(
        margin: EdgeInsets.all(8.0),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Text(
              news.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "publisher: ${news.source.name}",
                ),
                Text(
                  DateFormat("yyyy-mm-dd HH:ss").format(news.publishedAt),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
            news.urlToImage == null
                ? Container()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Divider(),
                      CachedNetworkImage(
                        imageUrl: news.urlToImage,
                        errorWidget: (context, s, b) => Container(),
                      ),
                    ],
                  ),
            Divider(),
            Text(
              news.description,
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
