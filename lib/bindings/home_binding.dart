import 'package:get/get.dart';
import 'package:news_app/controllers/favorite_controller.dart';

class NewsBinding extends Bindings {
  @override
  void dependencies() async {
    Get.put(FavoriteController());
  }
}
