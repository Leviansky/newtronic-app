// ignore_for_file: avoid_print, body_might_complete_normally_nullable

import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:newtronic_app/app/models/response.dart';
import 'package:newtronic_app/app/modules/product/controllers/product_controller.dart';
import 'package:newtronic_app/app/services/network_service.dart';
import 'package:newtronic_app/resources/dummy_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ProductRepository {
  var network = NetworkService.to;

  Future<ResponseProduct?> getAllResponse() async {
    try {
      var url = '/api/directory/dataList';
      final response = await network.get(url: url);
      response.data['data'].add(dummy);
      return ResponseProduct.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool?> downloadFile({
    required String url,
  }) async {
    try {
      // if (await Permission.storage.request().isGranted) {
      final baseStorage = await getExternalStorageDirectory();
      print('-----------');
      print(baseStorage);
      await FlutterDownloader.enqueue(
        url: url,
        headers: {},
        savedDir: baseStorage!.path,
        showNotification: true,
        openFileFromNotification: true,
      );
      // }
      return Future.value(true);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isFileExists(String fileName) async {
    try {
      Directory? baseStorage = await getExternalStorageDirectory();
      if (baseStorage != null) {
        String directoryPath = baseStorage.path;
        File fileToCheck = File('$directoryPath/$fileName');
        print('$directoryPath/$fileName');
        return await fileToCheck.exists();
      } else {
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
