import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController with SingleGetTickerProviderMixin {
  TabController controller;
  // Rx<List<NewsModel>> favorites = Rx(<NewsModel>[]);
  // SharedPreferences box;

  // List<NewsModel> get checkFavorites => favorites?.value;

  final List<Tab> myTabs = <Tab>[
    Tab(
      text: 'Top headlines',
    ),
    Tab(
      text: 'Everything',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    controller = TabController(vsync: this, length: myTabs.length);
    // getFavorites();
  }

  // void getFavorites() async {
  //   box = await SharedPreferences.getInstance();
  //   favorites.value = box.getString("favorites") != null
  //       ? newsModelFromJson(box.getString("favorites"))
  //       : <NewsModel>[];
  // }

  // void addFavorite(NewsModel news) {
  //   favorites.value.add(news);
  //   box.setString("favorites", newsModelToJson(favorites.value));
  //   // update();
  //   Get.snackbar(
  //     "Новость добавлен избранные",
  //     "",
  //     snackPosition: SnackPosition.BOTTOM,
  //     duration: Duration(
  //       seconds: 1,
  //     ),
  //   );
  // }

  // void removeFromFavorite(NewsModel news) {
  //   favorites.value.removeWhere((element) =>
  //       element.publishedAt.microsecondsSinceEpoch ==
  //       news.publishedAt.microsecondsSinceEpoch);
  //   box.setString("favorites", newsModelToJson(favorites.value));
  //   Get.snackbar(
  //     "Новость удален из избранных",
  //     "",
  //     snackPosition: SnackPosition.BOTTOM,
  //     duration: Duration(
  //       seconds: 1,
  //     ),
  //   );
  //   // update();
  // }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
