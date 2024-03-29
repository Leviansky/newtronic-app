// ignore_for_file: avoid_print, body_might_complete_normally_nullable

import 'dart:io';
import 'package:newtronic_app/app/models/response.dart';
import 'package:newtronic_app/app/services/network_service.dart';
import 'package:newtronic_app/resources/dummy_data.dart';
import 'package:path_provider/path_provider.dart';

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
