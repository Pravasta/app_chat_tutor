// To parse this JSON data, do
//
//     final users = usersFromJson(jsonString);

import 'dart:convert';

UsersModel usersFromJson(String str) => UsersModel.fromJson(json.decode(str));

String usersToJson(UsersModel data) => json.encode(data.toJson());

class UsersModel {
  UsersModel({
    this.uid,
    this.name,
    this.keyName,
    this.email,
    this.createAt,
    this.updateAt,
    this.photoUrl,
    this.status,
    this.updateTime,
    this.chats,
  });

  String? uid;
  String? name;
  String? keyName;
  String? email;
  String? createAt;
  String? updateAt;
  String? photoUrl;
  String? status;
  String? updateTime;
  List<ChatUsers>? chats;

  factory UsersModel.fromJson(Map<String, dynamic> json) => UsersModel(
        uid: json["uid"],
        name: json["name"],
        keyName: json["keyName"],
        email: json["email"],
        createAt: json["createAt"],
        updateAt: json["updateAt"],
        photoUrl: json["photoUrl"],
        status: json["status"],
        updateTime: json["updateTime"],
        // chats: List<ChatUsers>.from(
        //     json["chats"].map((x) => ChatUsers.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "keyName": keyName,
        "email": email,
        "createAt": createAt,
        "updateAt": updateAt,
        "photoUrl": photoUrl,
        "status": status,
        "updateTime": updateTime,
        // "chats": List<dynamic>.from(chats!.map((x) => x.toJson())),
      };
}

class ChatUsers {
  ChatUsers({
    this.connection,
    this.chatId,
    this.lastTime,
    this.totalUnread,
  });

  String? connection;
  String? chatId;
  String? lastTime;
  int? totalUnread;

  factory ChatUsers.fromJson(Map<String, dynamic> json) => ChatUsers(
        connection: json["connection"],
        chatId: json["chat_id"],
        lastTime: json["lastTime"],
        totalUnread: json["total_unread"],
      );

  Map<String, dynamic> toJson() => {
        "connection": connection,
        "chat_id": chatId,
        "lastTime": lastTime!,
        "total_unread": totalUnread,
      };
}
