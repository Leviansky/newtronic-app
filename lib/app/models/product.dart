import 'package:newtronic_app/app/models/playlist.dart';

class Product {
  int? id;
  String? title;
  String? description;
  String? banner;
  String? logo;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Playlist>? playlist;

  Product({
    this.id,
    this.title,
    this.description,
    this.banner,
    this.logo,
    this.createdAt,
    this.updatedAt,
    this.playlist,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        banner: json["banner"],
        logo: json["logo"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        playlist: json["playlist"] == null
            ? []
            : List<Playlist>.from(
                json["playlist"]!.map((x) => Playlist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "banner": banner,
        "logo": logo,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "playlist": playlist == null
            ? []
            : List<dynamic>.from(playlist!.map((x) => x.toJson())),
      };
}
