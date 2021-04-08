import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
import 'package:news_app/bindings/home_binding.dart';
import 'package:news_app/pages/home_page.dart';

void main() async {
  // await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        enableLog: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            centerTitle: true,
          ),
          brightness: Brightness.light,
          primarySwatch: Colors.amber,
          primaryColor: Colors.white,
          accentColor: Colors.amber,
        ),
        darkTheme: ThemeData(
          appBarTheme: AppBarTheme(
            centerTitle: true,
          ),
          brightness: Brightness.dark,
          primarySwatch: Colors.amber,
          primaryColor: Colors.black,
          accentColor: Colors.amber,
        ),
        initialBinding: HomeBinding(),
        home: HomePage());
  }
}
