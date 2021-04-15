import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/favorite_controller.dart';
import 'package:news_app/controllers/news_controller.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/pages/detail.dart';
import 'package:news_app/pages/favorites_page.dart';

class TopHeadlinesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TopHeadlinesController topHeadlinesController =
        Get.put(TopHeadlinesController());
    return Scaffold(
      floatingActionButton: GetBuilder<FavoriteController>(
        builder: (favoriteController) {
          if (favoriteController.favorites.value.isEmpty)
            return Container();
          else
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                onPressed: () => Get.to(FavoritesPage()),
                child: Icon(Icons.bookmarks),
              ),
            );
        },
      ),
      drawer: Drawer(),
      appBar: AppBar(
        title: Text("Лента новостей"),
        actions: [
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          topHeadlinesController.getTopNews(isRefresh: true);
        },
        child: GetBuilder<TopHeadlinesController>(
          builder: (controller) => Stack(
            children: [
              Obx(
                () {
                  return Stack(
                    children: [
                      topHeadlinesController.topNews.value.isEmpty &&
                              topHeadlinesController.newsCache.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Пусто..."),
                                  IconButton(
                                    icon: Icon(Icons.refresh),
                                    onPressed:
                                        topHeadlinesController.getTopNews,
                                  ),
                                ],
                              ),
                            )
                          : feed(
                              topHeadlinesController.topNews.value.isNotEmpty
                                  ? topHeadlinesController.topNews.value
                                  : topHeadlinesController.newsCache,
                              topHeadlinesController.scrollController,
                              topHeadlinesController.loadingMore.value,
                            ),
                      topHeadlinesController.loading.value
                          ? Align(
                              alignment: Alignment.topCenter,
                              child: LinearProgressIndicator(),
                            )
                          : Container(),
                      Positioned(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: controller.refresher.value
                              ? ElevatedButton(
                                  onPressed: () async {
                                    topHeadlinesController.getTopNews(
                                        isRefresh: true);
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.arrow_upward),
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      Text("Есть свежие новости"),
                                    ],
                                  ),
                                )
                              : Container(),
                        ),
                      )
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget feed(
      List<NewsModel> list, ScrollController controller, bool isLoadMore) {
    return Scrollbar(
      thickness: 10.0,
      radius: Radius.circular(10.0),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 4.0,
        ),
        controller: controller,
        itemCount: list.length + 1,
        itemBuilder: (context, index) {
          if (index == list.length)
            return Center(
              child: Container(
                height: 30.0,
                width: 30.0,
                padding: const EdgeInsets.all(4.0),
                child: !isLoadMore ? Container() : CircularProgressIndicator(),
              ),
            );
          return Container(
            height: 98.0,
            child: Card(
              child: ListTile(
                onTap: () {
                  Get.to(DetailPage(news: list[index]));
                },
                title: Text(
                  list[index].title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  list[index].description ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Container(
                  height: 70.0,
                  width: 70.0,
                  child: list[index].urlToImage == null
                      ? null
                      : CachedNetworkImage(
                          imageUrl: list[index].urlToImage,
                          memCacheWidth: 256,
                          errorWidget: (context, s, b) =>
                              Icon(Icons.image_not_supported_sharp),
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
