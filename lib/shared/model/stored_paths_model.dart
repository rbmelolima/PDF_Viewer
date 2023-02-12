import 'dart:convert';

class StoredPathsModel {
  StoredPathsModel({
    required this.path,
    required this.name,
    required this.date,
    required this.favorite,
  });

  final String path;
  final String name;
  final DateTime date;
  final bool favorite;

  factory StoredPathsModel.fromRawJson(String str) =>
      StoredPathsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StoredPathsModel.fromJson(Map<String, dynamic> json) =>
      StoredPathsModel(
        path: json["path"],
        name: json["name"],
        date: DateTime.parse(json["date"]),
        favorite: json["favorite"],
      );

  Map<String, dynamic> toJson() => {
        "path": path,
        "name": name,
        "date": date.toIso8601String(),
        "favorite": favorite,
      };

  @override
  String toString() {
    return "StoredPathsModel(path: $path, name: $name, date: $date, favorite: $favorite)";
  }
}
