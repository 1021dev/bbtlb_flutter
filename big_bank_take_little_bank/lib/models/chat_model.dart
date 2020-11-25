import 'dart:core';

import 'package:big_bank_take_little_bank/models/last_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'chat_user_model.dart';

class ChatModel {
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  List<ChatUser> users;
  List<String> members;
  String type;
  LastMessage lastMessage;

  DocumentReference reference;

  ChatModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.users,
    this.members,
    this.lastMessage,
    this.reference,
    this.type,
  });

  factory ChatModel.fromJson(Map<dynamic, dynamic> json) {
    // List<ChatUser> chatUsers = [];
    // if (json['users'] != null) {
    //   dynamic userArr = json['users'];
    //   if (userArr is List) {
    //     userArr.forEach((element) {
    //       chatUsers.add(ChatUser.fromJson(element));
    //     });
    //   }
    // }
    List<String> members = [];
    dynamic list = json['members'];
    if (list is List) {
      list.forEach((element) {
        members.add(element.toString());
      });
    }
    return ChatModel(
      id: json['id'] as String ?? '',
      members: members,
      createdAt: (json['createdAt'] as Timestamp).toDate() ?? DateTime.now(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate() ?? DateTime.now(),
      // type: json['type'] != null ? json['type'] as String ?? 'public': 'public',
      // users: chatUsers,
      // lastMessage: json['lastMessage'] != null ? LastMessage.fromJson(json['lastMessage']) ?? LastMessage() : null,
    );
  }

  Map<String, dynamic> toJson() => _chatToJson(this);

  @override
  String toString() => "ChatModel  <>";

  Map<String, dynamic> _chatToJson(ChatModel instance) {
    List<dynamic> userArr = [];
    instance.users.forEach((element) {
      userArr.add(element.toJson());
    });
    return {
      'reference': instance.reference,
      'id': instance.id ?? '',
      'createdAt': Timestamp.fromDate(instance.createdAt ?? DateTime.now()),
      'updatedAt': Timestamp.fromDate(instance.updatedAt ?? DateTime.now()),
      'members': instance.members ?? [],
      'type': instance.type ?? 'public',
      'users': userArr,
      'lastMessage': instance.lastMessage.toJson(),
    };
  }

}