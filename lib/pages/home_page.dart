import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/favorite_controller.dart';
import 'package:news_app/controllers/home_controller.dart';
import 'package:news_app/pages/everything_page.dart';
import 'package:news_app/pages/favorites_page.dart';
import 'package:news_app/pages/settings_page.dart';
import 'package:news_app/pages/top_headlines_page.dart';

class HomePage extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
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
                child: Icon(Icons.bookmark),
              ),
            );
        },
      ),
      appBar: AppBar(
        title: Text("NewsApp"),
        bottom: TabBar(
          controller: controller.controller,
          tabs: controller.myTabs,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Get.to(SettingsPage()),
          ),
        ],
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: controller.controller,
            children: List.generate(controller.myTabs.length, (index) {
              switch (index) {
                case 0:
                  return TopHeadlinesPage();
                  break;
                default:
                  return EverythingPage();
              }
            }),
          ),
        ],
      ),
    );
  }
}
