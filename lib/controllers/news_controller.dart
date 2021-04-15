// import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
import 'package:news_app/network/connection.dart';
import 'package:news_app/models/news_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopHeadlinesController extends GetxController {
  RxBool loading = false.obs;
  RxBool loadingMore = false.obs;
  Rx<List<NewsModel>> topNews = Rx(<NewsModel>[]);
  List<NewsModel> newsCache = <NewsModel>[];
  SharedPreferences box;
  int page = 1;
  ScrollController scrollController = ScrollController();
  Timer timer;
  RxBool refresher = false.obs;
  String apiKey = "a60eacfd3a6e4a3badf40b66adba64a3";
  String currentTheme = "policy";

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
    // topNews.value = newsCache;
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
    getTopNews(isRefresh: true);
  }

  void isLoad(bool value, {isRefresh: false}) {
    if(isRefresh){
      loading.value = value;
    }else{
      loadingMore.value = value;
    }
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
    if (!loading.value) {
      refresher.value = false;
      timer?.cancel();
      isLoad(true, isRefresh: isRefresh);
      List<NewsModel> response = await Connection.fetchNews(
        "https://newsapi.org/v2/everything?q=$currentTheme&pageSize=15&page=${isRefresh ? "1" : page}&language=ru&apiKey=$apiKey",
      );
      isLoad(false, isRefresh: isRefresh);
      if (response.isNotEmpty) {
        if (isRefresh) topNews.value = <NewsModel>[];
        newsParse(response);
        isRefresh ? page = 2 : page++;
      }
      timerToRefresh();
    }
  }

  Future getRefreshData() async {
    timer?.cancel();
    List<NewsModel> response = await Connection.fetchNews(
      "https://newsapi.org/v2/everything?q=$currentTheme&pageSize=15&page=1&language=ru&apiKey=$apiKey",
      withTimer: true,
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
