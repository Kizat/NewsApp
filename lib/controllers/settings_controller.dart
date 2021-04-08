import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  SharedPreferences box;
  RxString apiKey = "02b69815565b4cfabf05782b67a83299".obs;
  RxString theme = "apple".obs;
  RxBool isDefault = true.obs;
  String currentApiKey = "02b69815565b4cfabf05782b67a83299";
  String currentTheme = "apple";

  @override
  void onInit() {
    super.onInit();
    // apiKey.value = "";
    getPreferences();
  }

  void getPreferences() async {
    box = await SharedPreferences.getInstance();
    if (box.getString("theme") != null) {
      apiKey.value = box.getString("api_key");
      currentApiKey = box.getString("api_key");
      theme.value = box.getString("theme");
      currentTheme = box.getString("theme");
    }
    update();
  }

  void setApiKey(String newApiKey) {
    apiKey.value = newApiKey;
    isDefault.value =
        apiKey.value == currentApiKey && theme.value == currentTheme;
    update();
  }

  void setTheme(String newTheme) {
    theme.value = newTheme;
    isDefault.value =
        theme.value == currentTheme && apiKey.value == currentApiKey;
    update();
  }

  void allSettingsUpdate() {
    if (apiKey.value == "" || theme.value == "") {
      Get.snackbar(
        "All fields must be filled",
        "",
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      currentApiKey = apiKey.value;
      currentTheme = theme.value;
      box.setString("api_key", currentApiKey);
      box.setString("theme", currentTheme);
      Get.back();
      Get.snackbar(
        "Settings was saved",
        "",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void setDefault() {
    apiKey.value = "02b69815565b4cfabf05782b67a83299";
    currentApiKey = "02b69815565b4cfabf05782b67a83299";
    theme.value = "apple";
    currentTheme = "apple";
    box.setString("api_key", currentApiKey);
    box.setString("theme", currentTheme);
    Get.back();
    Get.snackbar(
      "Settings was refreshed",
      "",
      snackPosition: SnackPosition.BOTTOM,
    );
    // Get.back();
    update();
  }
}
