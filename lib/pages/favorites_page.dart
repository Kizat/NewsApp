import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/favorite_controller.dart';
import 'package:news_app/pages/detail.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final favoriteController = Get.find<FavoriteController>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Избранное"),
      ),
      body: GetBuilder<FavoriteController>(
        builder: (favoriteController) {
          return favoriteController.favorites.value.isEmpty
              ? Center(
                  child: Text("Пусто..."),
                )
              : ListView.builder(
                  itemCount: favoriteController.favorites.value.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        onTap: () => Get.to(DetailPage(
                            news: favoriteController.favorites.value[index])),
                        title: Text(
                            favoriteController.favorites.value[index].title),
                        subtitle: Text(favoriteController
                                .favorites.value[index].description ??
                            ""),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
