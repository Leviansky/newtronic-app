// To parse this JSON data, do
//
//     final response = responseFromJson(jsonString);

import 'dart:convert';

import 'package:newtronic_app/app/models/product.dart';

ResponseProduct responseFromJson(String str) =>
    ResponseProduct.fromJson(json.decode(str));

String responseToJson(ResponseProduct data) => json.encode(data.toJson());

class ResponseProduct {
  List<Product>? data;
  int? status;

  ResponseProduct({
    this.data,
    this.status,
  });

  factory ResponseProduct.fromJson(Map<String, dynamic> json) =>
      ResponseProduct(
        data: json["data"] == null
            ? []
            : List<Product>.from(json["data"]!.map((x) => Product.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "status": status,
      };
}
