import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:news_app/models/news_model.dart';

class Connection {
  static Future<List<NewsModel>> fetchNews(String url,
      {bool withTimer: false}) async {
    List<NewsModel> result = <NewsModel>[];
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        log(jsonDecode(response.body)['totalResults'].toString());
        // _showErrorMessage(
        //     "Произошла ошибка", "${jsonDecode(response.body)['articles'][0]['title']}");
        result = newsModelFromJson(
            jsonEncode(jsonDecode(response.body)['articles']));
      } else {
        if(!withTimer)_showErrorMessage(
            "Пройзошла ошибка", "${jsonDecode(response.body)['message']}");
      }
    } on SocketException catch (_) {
      if(!withTimer)_showErrorMessage("Нет соединения с интернетом", "");
    } catch (e) {
      if(!withTimer)_showErrorMessage("Пройзошла ошибка", "$e");
    }
    return result;
  }

  static _showErrorMessage(String title, String text) {
    Get.snackbar(
      "$title",
      "$text",
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 5),
    );
  }
}
