import 'package:big_bank_take_little_bank/models/chat_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  ChatUser user;
  String message;
  String type;
  bool isRead;
  String replyId;
  num replyCount;

  DocumentReference reference;

  MessageModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.message,
    this.reference,
    this.type,
    this.isRead,
    this.replyId,
    this.replyCount,
  });

  factory MessageModel.fromJson(Map<dynamic, dynamic> json) {
    return MessageModel(
      reference: json['reference'] as DocumentReference,
      id: json['id'] as String ?? '',
      user: ChatUser.fromJson(json['user']) ?? ChatUser(),
      message: json['message'] as String ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate() ?? DateTime.now(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate() ?? DateTime.now(),
      type: json['type'] as String ?? 'public',
      isRead: json['isRead'] as bool ?? false,
      replyId: json['replyId'] ?? '',
      replyCount: json['replyCount'] as num ?? 0,
    );
  }

  Map<String, dynamic> toJson() => _commentToJson(this);

  @override
  String toString() => "Message  <$id>";

  Map<String, dynamic> _commentToJson(MessageModel instance) =>
      <String, dynamic> {
        'reference': instance.reference,
        'id': instance.id ?? '',
        'createdAt': Timestamp.fromDate(instance.createdAt ?? DateTime.now()),
        'updatedAt': Timestamp.fromDate(instance.updatedAt ?? DateTime.now()),
        'user': instance.user.toJson(),
        'message': instance.message ?? '',
        'type': instance.type ?? 'public',
        'isRead': instance.isRead ?? false,
        'replyId': instance.replyId ?? null,
        'replyCount': instance.replyCount ?? 0,
      };

}