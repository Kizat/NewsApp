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
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
        actions: [
          GetBuilder<FavoriteController>(
            builder: (favoriteController) => favoriteController.favorites.value
                    .where((element) =>
                        element.publishedAt.microsecondsSinceEpoch ==
                        news.publishedAt.microsecondsSinceEpoch)
                    .isEmpty
                ? IconButton(
                    icon: Icon(Icons.star_border),
                    onPressed: () {
                      favoriteController.addFavorite(news);
                    },
                  )
                : IconButton(
                    color: Get.theme.accentColor,
                    icon: Icon(Icons.star),
                    onPressed: () {
                      favoriteController.removeFromFavorite(news);
                    },
                  ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
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
              : Image.network(
                news.urlToImage,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent loadingProgress) {
                  if (loadingProgress == null)
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [Divider(), child],
                    );
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, object, stackTrace) {
                  return Container();
                },
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
    );
  }
}
