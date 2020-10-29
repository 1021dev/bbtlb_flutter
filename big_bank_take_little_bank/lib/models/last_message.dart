import 'package:big_bank_take_little_bank/models/chat_user_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LastMessage {
  ChatUser user;
  String lastMessageId;
  DateTime createdAt;
  DateTime updatedAt;
  String message;
  String type;

  DocumentReference reference;

  LastMessage({
    this.user,
    this.lastMessageId,
    this.createdAt,
    this.updatedAt,
    this.message,
    this.reference,
    this.type,
  });

  factory LastMessage.fromJson(Map<dynamic, dynamic> json) {
    return LastMessage(
      reference: json['reference'] as DocumentReference,
      user: ChatUser.fromJson(json['user'] ) ?? ChatUser(),
      lastMessageId: json['lastMessageId'] as String ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate() ?? DateTime.now(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate() ?? DateTime.now(),
      message: json['message'] as String ?? '',
      type: json['type'] as String ?? 'public',
    );
  }

  Map<String, dynamic> toJson() => _commentToJson(this);

  @override
  String toString() => "LastMessage  <$lastMessageId>";

  Map<String, dynamic> _commentToJson(LastMessage instance) =>
      <String, dynamic> {
        'reference': instance.reference,
        'lastMessageId': instance.lastMessageId ?? '',
        'user': instance.user.toJson() ?? '',
        'createdAt': Timestamp.fromDate(instance.createdAt ?? DateTime.now()),
        'updatedAt': Timestamp.fromDate(instance.updatedAt ?? DateTime.now()),
        'message': instance.message ?? '',
        'type': instance.type ?? 'public',
      };

}