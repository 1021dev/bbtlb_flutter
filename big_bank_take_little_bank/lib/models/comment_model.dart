import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  String userId;
  String userName;
  String userImage;
  String comment;

  DocumentReference reference;

  CommentModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.userName,
    this.userImage,
    this.userId,
    this.comment,
    this.reference,
  });

  factory CommentModel.fromJson(Map<dynamic, dynamic> json) {
    return CommentModel(
      reference: json['reference'] as DocumentReference,
      id: json['id'] as String ?? '',
      userName: json['userName'] as String ?? '',
      userId: json['userId'] as String ?? '',
      userImage: json['userImage'] as String ?? '',
      comment: json['comment'] as String ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate() ?? DateTime.now(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => _commentToJson(this);

  @override
  String toString() => "Gallery  <$id>";


  Map<String, dynamic> _commentToJson(CommentModel instance) =>
      <String, dynamic> {
        'reference': instance.reference,
        'id': instance.id ?? '',
        'createdAt': Timestamp.fromDate(instance.createdAt ?? DateTime.now()),
        'updatedAt': Timestamp.fromDate(instance.updatedAt ?? DateTime.now()),
        'userId': instance.userId ?? '',
        'userName': instance.userName ?? '',
        'userImage': instance.userImage ?? '',
        'comment': instance.comment ?? '',
      };

}