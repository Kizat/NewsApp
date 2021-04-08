import 'package:get/get.dart';
import 'package:news_app/controllers/favorite_controller.dart';
import 'package:news_app/controllers/home_controller.dart';
import 'package:news_app/controllers/settings_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() async {
    Get.put(HomeController());
    Get.put(FavoriteController());
    Get.put(SettingsController());
  }
}
