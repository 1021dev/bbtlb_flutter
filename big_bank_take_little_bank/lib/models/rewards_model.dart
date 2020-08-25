import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class RewardsModel {
  String id;
  DateTime rewardsAt;
  num rewardPoint;
  num consecutive;
  String type;

  DocumentReference reference;

  RewardsModel({
    this.id,
    this.rewardsAt,
    this.rewardPoint,
    this.consecutive,
    this.type,
  });

  factory RewardsModel.fromJson(Map<dynamic, dynamic> json) {
    return RewardsModel(
      id: json['id'] as String ?? '',
      rewardPoint: json['rewardPoint'] as num ?? 0,
      consecutive: json['consecutive'] as num ?? 0,
      type: json['type'] as String ?? 'daily',
      rewardsAt: (json['rewardsAt'] as Timestamp).toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => _rewardsToJson(this);

  @override
  String toString() => "FirebaseUser <$id>";


  Map<String, dynamic> _rewardsToJson(RewardsModel instance) =>
      <String, dynamic> {
        'id': instance.id ?? '',
        'rewardsAt': Timestamp.fromDate(instance.rewardsAt ?? DateTime.now()),
        'type': instance.type ?? 'daily',
        'consecutive': instance.consecutive ?? 0,
        'rewardPoint': instance.rewardPoint ?? 0,
      };

}