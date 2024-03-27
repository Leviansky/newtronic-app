import 'package:newtronic_app/app/models/response.dart';
import 'package:newtronic_app/app/services/network_service.dart';
import 'package:newtronic_app/resources/dummy_data.dart';

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
}
