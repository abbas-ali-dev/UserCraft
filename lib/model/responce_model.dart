// To parse this JSON data, do
//
//     final responceModel = responceModelFromJson(jsonString);

import 'dart:convert';

ResponceModel responceModelFromJson(String str) =>
    ResponceModel.fromJson(json.decode(str));

String responceModelToJson(ResponceModel data) => json.encode(data.toJson());

class ResponceModel {
  int? userId;
  int? id;
  String? title;
  String? body;

  ResponceModel({
    this.userId,
    this.id,
    this.title,
    this.body,
  });

  factory ResponceModel.fromJson(Map<String, dynamic> json) => ResponceModel(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "body": body,
      };
}
