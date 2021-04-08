import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/top_headlines_controller.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/pages/detail.dart';

class TopHeadlinesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TopHeadlinesController topHeadlinesController =
        Get.put(TopHeadlinesController());
    return RefreshIndicator(
      onRefresh: () async {
        topHeadlinesController.getTopNews(isRefresh: true);
      },
      child: GetBuilder<TopHeadlinesController>(
        builder: (controller) => Stack(
          children: [
            Obx(() {
              if (topHeadlinesController.loading.value &&
                  topHeadlinesController.topNews.value.isEmpty) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (topHeadlinesController.topNews.value.isNotEmpty) {
                  return feed(
                      topHeadlinesController.topNews.value,
                      topHeadlinesController.scrollController,
                      topHeadlinesController.loading.value);
                } else {
                  if (topHeadlinesController.newsCache.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Empty..."),
                          IconButton(
                            icon: Icon(Icons.refresh),
                            onPressed: topHeadlinesController.getTopNews,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return feed(
                      topHeadlinesController.newsCache,
                      topHeadlinesController.scrollController,
                      topHeadlinesController.loading.value,
                    );
                  }
                }
              }
            }),
            Positioned(
              child: Align(
                alignment: Alignment.topCenter,
                child: controller.refresher.value
                    ? ElevatedButton(
                        onPressed: () async {
                          topHeadlinesController.topNews.value = <NewsModel>[];
                          topHeadlinesController.getTopNews(isRefresh: true);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.refresh),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text("new feeds are exists"),
                          ],
                        ),
                      )
                    : Container(),
              ),
            ),
          ],
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
          return Card(
            child: ListTile(
              onTap: () {
                Get.to(DetailPage(news: list[index]));
              },
              title: Text(list[index].title),
              subtitle: Text(
                list[index].description ?? "",
              ),
            ),
          );
        },
      ),
    );
  }
}
