import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUser {
  String userId;
  String userName;
  String userImage;

  DocumentReference reference;

  ChatUser({
    this.userName,
    this.userImage,
    this.userId,
  });

  factory ChatUser.fromJson(Map<dynamic, dynamic> json) {
    return ChatUser(
      userName: json['userName'] as String ?? '',
      userId: json['userId'] as String ?? '',
      userImage: json['userImage'] as String ?? '',
    );
  }

  Map<String, dynamic> toJson() => _commentToJson(this);

  @override
  String toString() => "ChatUser  <$userId>";

  Map<String, dynamic> _commentToJson(ChatUser instance) =>
      <String, dynamic> {
        'userId': instance.userId ?? '',
        'userName': instance.userName ?? '',
        'userImage': instance.userImage ?? '',
      };

}