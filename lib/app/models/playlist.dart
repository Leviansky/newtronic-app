class Playlist {
  int? id;
  int? dirId;
  String? title;
  String? description;
  String? url;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;

  Playlist({
    this.id,
    this.dirId,
    this.title,
    this.description,
    this.url,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) => Playlist(
        id: json["id"],
        dirId: json["dir_id"],
        title: json["title"],
        description: json["description"],
        url: json["url"],
        type: json["type"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "dir_id": dirId,
        "title": title,
        "description": description,
        "url": url,
        "type": type,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
