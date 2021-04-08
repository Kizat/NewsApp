// import 'dart:convert';

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
import 'package:news_app/connection.dart';
import 'package:news_app/controllers/settings_controller.dart';
import 'package:news_app/models/news_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopHeadlinesController extends GetxController {
  RxBool loading = false.obs;
  Rx<List<NewsModel>> topNews = Rx(<NewsModel>[]);
  List<NewsModel> newsCache = <NewsModel>[];
  SharedPreferences box;
  int page = 1;
  ScrollController scrollController = ScrollController();
  Timer timer;
  RxBool refresher = false.obs;

  @override
  void onInit() {
    super.onInit();
    initState();
  }

  void initState() async {
    box = await SharedPreferences.getInstance();
    newsCache = box.getString("cache") != null
        ? newsModelFromJson(box.getString("cache"))
        : <NewsModel>[];
    scrollController?.addListener(() {
      if (scrollController?.position?.maxScrollExtent ==
              scrollController?.offset
          //  - Get.height / 2
          ) {
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
    topNews.value.addAll(data);
    await box.setString(
      "cache",
      newsModelToJson(topNews.value),
    );
  }

  void timerToRefresh() {
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (!loading.value) {
        getRefreshData();
      }
    });
  }

  Future getTopNews({bool isRefresh: false}) async {
    refresher.value = false;
    timer?.cancel();
    final settingsController = Get.find<SettingsController>();
    isLoad(true);
    List<NewsModel> response = await Connection.fetchNews(
      "https://newsapi.org/v2/top-headlines?q=${settingsController.currentTheme}&pageSize=15&page=${isRefresh ? "1" : page}&apiKey=${settingsController.currentApiKey}",
    );
    isLoad(false);
    if (response.isNotEmpty) {
      if (isRefresh) topNews.value = <NewsModel>[];
      newsParse(response);
      isRefresh ? page = 2 : page++;
    }
    timerToRefresh();
  }

  Future getRefreshData() async {
    timer?.cancel();
    final settingsController = Get.find<SettingsController>();
    log("https://newsapi.org/v2/top-headlines?q=${settingsController.currentTheme}&pageSize=15&page=1&apiKey=${settingsController.currentApiKey}");
    List<NewsModel> response = await Connection.fetchNews(
      "https://newsapi.org/v2/top-headlines?q=${settingsController.currentTheme}&pageSize=15&page=1&apiKey=${settingsController.currentApiKey}",
    );
    if (response.isNotEmpty) {
      refresher.value = response[0].title != topNews.value[0].title;
      update();
      timerToRefresh();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    scrollController?.dispose();
    super.dispose();
  }
}
