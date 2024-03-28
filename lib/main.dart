import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:newtronic_app/app/routes/app_pages.dart';
import 'package:newtronic_app/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Newtronic',
      theme: ThemeData(
        fontFamily: 'Nunito',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialBinding: BindingsBuilder(
        () {
          bindService();
        },
      ),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    ),
  );
}
