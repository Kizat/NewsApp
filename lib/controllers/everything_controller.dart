import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/connection.dart';
import 'package:news_app/controllers/settings_controller.dart';
import 'package:news_app/models/news_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EverythingCopntroller extends GetxController {
  RxBool loading = false.obs;
  Rx<List<NewsModel>> everythingNews = Rx(<NewsModel>[]);
  SharedPreferences box;
  int page = 1;
  ScrollController scrollController = ScrollController();
  RxBool refresher = false.obs;

  @override
  void onInit() {
    super.onInit();
    initState();
  }

  void initState() async {
    scrollController?.addListener(() {
      if (scrollController?.position?.maxScrollExtent ==
          scrollController?.offset) {
        if (!loading.value) {
          getTopNews();
        }
      }
    });
    getTopNews();
  }

  void isLoad(bool value) {
    loading.value = value;
  }

  void newsParse(List<NewsModel> data) async {
    everythingNews.value.addAll(data);
  }

  Future getTopNews({bool isRefresh: false}) async {
    refresher.value = false;
    final settingsController = Get.find<SettingsController>();
    isLoad(true);
    log("https://newsapi.org/v2/everything?q=${settingsController.currentTheme}&pageSize=15&page=${isRefresh ? "1" : page}&apiKey=${settingsController.currentApiKey}");
    List<NewsModel> response = await Connection.fetchNews(
      "https://newsapi.org/v2/everything?q=${settingsController.currentTheme}&pageSize=15&page=${isRefresh ? "1" : page}&apiKey=${settingsController.currentApiKey}",
    );
    isLoad(false);
    if (response.isNotEmpty) {
      if (isRefresh) everythingNews.value = <NewsModel>[];
      newsParse(response);
      isRefresh ? page = 2 : page++;
    }
  }
}
