import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUser {
  String userId;
  String userName;
  String userImage;
  String message;
  String type;

  DocumentReference reference;

  ChatUser({
    this.userName,
    this.userImage,
    this.userId,
    this.message,
    this.reference,
    this.type,
  });

  factory ChatUser.fromJson(Map<dynamic, dynamic> json) {
    return ChatUser(
      reference: json['reference'] as DocumentReference,
      userName: json['userName'] as String ?? '',
      userId: json['userId'] as String ?? '',
      userImage: json['userImage'] as String ?? '',
      message: json['message'] as String ?? '',
      type: json['type'] as String ?? 'public',
    );
  }

  Map<String, dynamic> toJson() => _commentToJson(this);

  @override
  String toString() => "ChatUser  <$userId>";

  Map<String, dynamic> _commentToJson(ChatUser instance) =>
      <String, dynamic> {
        'reference': instance.reference,
        'userId': instance.userId ?? '',
        'userName': instance.userName ?? '',
        'userImage': instance.userImage ?? '',
        'message': instance.message ?? '',
        'type': instance.type ?? 'public',
      };

}