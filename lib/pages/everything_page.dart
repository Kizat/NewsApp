import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/everything_controller.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/pages/detail.dart';

class EverythingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final EverythingCopntroller everythingController =
        Get.put(EverythingCopntroller());
    return RefreshIndicator(
      onRefresh: () async {
        everythingController.getTopNews(isRefresh: true);
      },
      child: Obx(() {
        if (everythingController.loading.value &&
            everythingController.everythingNews.value.isEmpty) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (everythingController.everythingNews.value.isNotEmpty) {
            return feed(
                everythingController.everythingNews.value,
                everythingController.scrollController,
                everythingController.loading.value);
          } else {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Empty..."),
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: everythingController.getTopNews,
                  ),
                ],
              ),
            );
          }
        }
      }),
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
