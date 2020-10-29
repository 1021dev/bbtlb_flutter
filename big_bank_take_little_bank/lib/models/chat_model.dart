import 'dart:core';

import 'package:big_bank_take_little_bank/models/last_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'chat_user_model.dart';

class ChatModel {
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  List<ChatUser> users;
  String message;
  String type;
  LastMessage lastMessage;

  DocumentReference reference;

  ChatModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.users,
    this.lastMessage,
    this.message,
    this.reference,
    this.type,
  });

  factory ChatModel.fromJson(Map<dynamic, dynamic> json) {
    List<ChatUser> chatUsers = [];
    dynamic userArr = json['users'];
    if (userArr is List) {
      userArr.forEach((element) {
        chatUsers.add(ChatUser.fromJson(element));
      });
    }
    return ChatModel(
      reference: json['reference'] as DocumentReference,
      id: json['id'] as String ?? '',
      message: json['message'] as String ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate() ?? DateTime.now(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate() ?? DateTime.now(),
      type: json['type'] as String ?? 'public',
      users: chatUsers,
      lastMessage: LastMessage.fromJson(json['lastMessage']) ?? LastMessage(),
    );
  }

  Map<String, dynamic> toJson() => _commentToJson(this);

  @override
  String toString() => "Message  <$id>";

  Map<String, dynamic> _commentToJson(ChatModel instance) {
    List<dynamic> userArr = [];
    instance.users.forEach((element) {
      userArr.add(element.toJson());
    });
    return {
      'reference': instance.reference,
      'id': instance.id ?? '',
      'createdAt': Timestamp.fromDate(instance.createdAt ?? DateTime.now()),
      'updatedAt': Timestamp.fromDate(instance.updatedAt ?? DateTime.now()),
      'message': instance.message ?? '',
      'type': instance.type ?? 'public',
      'users': userArr,
      'lastMessage': instance.lastMessage.toJson(),
    };
  }

}