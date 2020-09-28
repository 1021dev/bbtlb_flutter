import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  String userId;
  String userName;
  String userImage;
  String message;
  String type;

  DocumentReference reference;

  MessageModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.userName,
    this.userImage,
    this.userId,
    this.message,
    this.reference,
    this.type,
  });

  factory MessageModel.fromJson(Map<dynamic, dynamic> json) {
    return MessageModel(
      reference: json['reference'] as DocumentReference,
      id: json['id'] as String ?? '',
      userName: json['userName'] as String ?? '',
      userId: json['userId'] as String ?? '',
      userImage: json['userImage'] as String ?? '',
      message: json['message'] as String ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate() ?? DateTime.now(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate() ?? DateTime.now(),
      type: json['type'] as String ?? 'public',
    );
  }

  Map<String, dynamic> toJson() => _commentToJson(this);

  @override
  String toString() => "Gallery  <$id>";

  Map<String, dynamic> _commentToJson(MessageModel instance) =>
      <String, dynamic> {
        'reference': instance.reference,
        'id': instance.id ?? '',
        'createdAt': Timestamp.fromDate(instance.createdAt ?? DateTime.now()),
        'updatedAt': Timestamp.fromDate(instance.updatedAt ?? DateTime.now()),
        'userId': instance.userId ?? '',
        'userName': instance.userName ?? '',
        'userImage': instance.userImage ?? '',
        'message': instance.message ?? '',
        'type': instance.type ?? 'public',
      };

}