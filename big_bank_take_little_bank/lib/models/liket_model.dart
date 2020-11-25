import 'package:cloud_firestore/cloud_firestore.dart';

class LikeModel {
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  String userId;
  String userName;
  String userImage;
  bool like;

  DocumentReference reference;

  LikeModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.userName,
    this.userImage,
    this.userId,
    this.like,
    this.reference,
  });

  factory LikeModel.fromJson(Map<dynamic, dynamic> json) {
    return LikeModel(
      reference: json['reference'] as DocumentReference,
      id: json['id'] as String ?? '',
      userName: json['userName'] as String ?? '',
      userId: json['userId'] as String ?? '',
      userImage: json['userImage'] as String ?? '',
      like: json['like'] as bool ?? false,
      createdAt: (json['createdAt'] as Timestamp).toDate() ?? DateTime.now(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => _likeToJson(this);

  @override
  String toString() => "Gallery  <$id>";


  Map<String, dynamic> _likeToJson(LikeModel instance) =>
      <String, dynamic> {
        'reference': instance.reference,
        'id': instance.id ?? '',
        'createdAt': Timestamp.fromDate(instance.createdAt ?? DateTime.now()),
        'updatedAt': Timestamp.fromDate(instance.updatedAt ?? DateTime.now()),
        'userId': instance.userId ?? '',
        'userName': instance.userName ?? '',
        'userImage': instance.userImage ?? '',
        'like': instance.like ?? false,
      };

}