import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newtronic_app/app/routes/app_pages.dart';

void main() async {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Newtronic',
      theme: ThemeData(
        fontFamily: 'Nunito',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    ),
  );
}
