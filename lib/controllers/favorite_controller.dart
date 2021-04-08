import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/models/news_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteController extends GetxController {
  Rx<List<NewsModel>> favorites = Rx(<NewsModel>[]);
  SharedPreferences box;

  @override
  void onInit() {
    super.onInit();
    getFavorites();
  }

  void getFavorites() async {
    box = await SharedPreferences.getInstance();
    favorites.value = box.getString("favorites") != null
        ? newsModelFromJson(box.getString("favorites"))
        : <NewsModel>[];
    update();
  }

  void addFavorite(NewsModel news) {
    favorites.value.add(news);
    box.setString("favorites", newsModelToJson(favorites.value));
    // update();
    Get.snackbar(
      "News was added to favorites",
      "",
      icon: Icon(
        Icons.star,
        color: Get.theme.accentColor,
      ),
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(
        seconds: 1,
      ),
    );
    update();
  }

  void removeFromFavorite(NewsModel news) {
    favorites.value.removeWhere((element) =>
        element.publishedAt.microsecondsSinceEpoch ==
        news.publishedAt.microsecondsSinceEpoch);
    box.setString("favorites", newsModelToJson(favorites.value));
    Get.snackbar(
      "News was removed from favorites",
      "",
      icon: Icon(
        Icons.star_outline,
      ),
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(
        seconds: 1,
      ),
    );
    update();
  }
}
