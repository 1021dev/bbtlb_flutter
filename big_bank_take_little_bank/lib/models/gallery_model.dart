import 'package:cloud_firestore/cloud_firestore.dart';

class GalleryModel {
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  String image;
  String description;
  int likeCount;
  int commentCount;

  DocumentReference reference;

  GalleryModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.description,
    this.likeCount,
    this.commentCount,
    this.reference,
  });

  factory GalleryModel.fromJson(Map<dynamic, dynamic> json) {
    return GalleryModel(
      reference: json['reference'] as DocumentReference,
      id: json['id'] as String ?? '',
      image: json['image'] as String ?? '',
      description: json['description'] as String ?? '',
      likeCount: json['likeCount'] as int ?? 0,
      commentCount: json['commentCount'] as int ?? 0,
      createdAt: (json['createdAt'] as Timestamp).toDate() ?? DateTime.now(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => _galleryToJson(this);

  @override
  String toString() => "Gallery  <$id>";


  Map<String, dynamic> _galleryToJson(GalleryModel instance) =>
      <String, dynamic> {
        'reference': instance.reference,
        'id': instance.id ?? '',
        'createdAt': Timestamp.fromDate(instance.createdAt ?? DateTime.now()),
        'updatedAt': Timestamp.fromDate(instance.updatedAt ?? DateTime.now()),
        'image': instance.image ?? '',
        'description': instance.description ?? '',
        'likeCount': instance.likeCount ?? 0,
        'commentCount': instance.commentCount ?? 0,
      };

}