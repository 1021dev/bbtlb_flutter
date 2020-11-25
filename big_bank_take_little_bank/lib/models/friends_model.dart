import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class FriendsModel {
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  String image;
  String name;
  String sender;
  String receiver;
  String status;
  String block;

  DocumentReference reference;

  FriendsModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.name,
    this.sender,
    this.receiver,
    this.status = 'notFriends',
    this.block,
  });

  factory FriendsModel.fromJson(Map<dynamic, dynamic> json) {
    return FriendsModel(
      id: json['id'] as String ?? '',
      image: json['image'] as String ?? '',
      name: json['name'] as String ?? '',
      sender: json['sender'] as String ?? '',
      receiver: json['receiver'] as String ?? '',
      block: json['block'] as String ?? '',
      status: json['status'] as String ?? 'notFriends',
      createdAt: (json['createdAt'] as Timestamp).toDate() ?? DateTime.now(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => _friendsToJson(this);

  @override
  String toString() => "FirebaseUser <$id>";


  Map<String, dynamic> _friendsToJson(FriendsModel instance) =>
      <String, dynamic> {
        'id': instance.id ?? '',
        'createdAt': Timestamp.fromDate(instance.createdAt ?? DateTime.now()),
        'updatedAt': Timestamp.fromDate(instance.updatedAt ?? DateTime.now()),
        'image': instance.image ?? '',
        'name': instance.name ?? '',
        'sender': instance.sender ?? '',
        'receiver': instance.receiver ?? '',
        'status': instance.status ?? 'notFriends',
        'block': instance.block ?? '',
      };

  String getGroup() {
    if (name != null && name != '') {
      return '${name.toUpperCase()[0]}';
    }
    return '';
  }
}

class FriendsGroupModel {
  FriendsModel friendsModel;
  String group;

  FriendsGroupModel({
   this.friendsModel,
   this.group,
  });
}