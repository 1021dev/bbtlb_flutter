import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class ChallengeModel {
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  String sender;
  String receiver;
  String status;
  String type;
  String winner;
  String loser;
  String result;
  num points;
  String tasks;
  DateTime challengeTime;

  DocumentReference reference;

  ChallengeModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.sender,
    this.receiver,
    this.status = 'pending',
    this.type,
    this.winner,
    this.loser,
    this.result,
    this.tasks,
    this.points = 0,
    this.challengeTime,
  });

  factory ChallengeModel.fromJson(Map<dynamic, dynamic> json) {
    return ChallengeModel(
      id: json['id'] as String ?? '',
      sender: json['sender'] as String ?? '',
      receiver: json['receiver'] as String ?? '',
      status: json['status'] as String ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate() ?? DateTime.now(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate() ?? DateTime.now(),
      type: json['type'] as String ?? '',
      winner: json['winner'] as String ?? '',
      loser: json['loser'] as String ?? '',
      result: json['result'] as String ?? '',
      tasks: json['tasks'] as String ?? '',
      points: json['points'] as num ?? 0,
      challengeTime: (json['challengeTime'] as Timestamp).toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => _challengeToJson(this);

  @override
  String toString() => "FirebaseUser <$id>";


  Map<String, dynamic> _challengeToJson(ChallengeModel instance) =>
      <String, dynamic> {
        'id': instance.id ?? '',
        'createdAt': Timestamp.fromDate(instance.createdAt ?? DateTime.now()),
        'updatedAt': Timestamp.fromDate(instance.updatedAt ?? DateTime.now()),
        'sender': instance.sender ?? '',
        'receiver': instance.receiver ?? '',
        'status': instance.status ?? '',
        'type': instance.type ?? '',
        'winner': instance.winner ?? '',
        'loser': instance.loser ?? '',
        'result': instance.result ?? '',
        'points': instance.points ?? 0,
        'tasks': instance.tasks ?? '',
        'challengeTime': Timestamp.fromDate(instance.challengeTime ?? DateTime.now()),
      };

}