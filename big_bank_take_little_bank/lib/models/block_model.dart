import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class BlockModel {
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  String image;
  String name;
  String sender;
  String receiver;
  String status;

  DocumentReference reference;

  BlockModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.name,
    this.sender,
    this.receiver,
    this.status = 'block',
  });

  factory BlockModel.fromJson(Map<dynamic, dynamic> json) {
    return BlockModel(
      id: json['id'] as String ?? '',
      image: json['image'] as String ?? '',
      name: json['name'] as String ?? '',
      sender: json['sender'] as String ?? '',
      receiver: json['receiver'] as String ?? '',
      status: json['status'] as String ?? 'notFriends',
      createdAt: (json['createdAt'] as Timestamp).toDate() ?? DateTime.now(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => _blockToJson(this);

  @override
  String toString() => "FirebaseUser <$id>";


  Map<String, dynamic> _blockToJson(BlockModel instance) =>
      <String, dynamic> {
        'id': instance.id ?? '',
        'createdAt': Timestamp.fromDate(instance.createdAt ?? DateTime.now()),
        'updatedAt': Timestamp.fromDate(instance.updatedAt ?? DateTime.now()),
        'image': instance.image ?? '',
        'name': instance.name ?? '',
        'sender': instance.sender ?? '',
        'receiver': instance.receiver ?? '',
        'status': instance.status ?? 'notFriends',
      };

  String getGroup() {
    if (name != null && name != '') {
      return '${name.toUpperCase()[0]}';
    }
    return '';
  }
}