import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String deviceToken;
  String email;
  String facebookId;
  String id;
  String image;
  String profession;
  String userType;
  num age;
  bool isFacebookUser;
  bool isLoggedIn;
  bool notification;
  String address;
  String location;
  num totalChallenge;
  num totalDecline;
  num totalAccept;
  num totalWin;
  num totalRequest;
  num totalPlayed;
  num totalLoss;
  num totalAccepted;
  num totalDeclined;
  num totalGamePlayed;
  num points;
  num level;
  bool isAdmin;
  DateTime rewardsAt;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime loginAt;
  num consecutiveWin;
  num consecutiveLogin;
  
  DocumentReference reference;
  
  UserModel({
    this.name,
    this.email,
    this.id,
    this.profession,
    this.age,
    this.location,
    this.image,
    this.deviceToken,
    this.facebookId,
    this.userType,
    this.isFacebookUser,
    this.isLoggedIn,
    this.notification,
    this.address,
    this.totalChallenge,
    this.totalGamePlayed,
    this.totalDecline,
    this.totalAccept,
    this.totalWin,
    this.totalRequest,
    this.totalPlayed,
    this.totalLoss,
    this.totalAccepted,
    this.totalDeclined,
    this.points,
    this.level,
    this.isAdmin,
    this.rewardsAt,
    this.createdAt,
    this.updatedAt,
    this.loginAt,
    this.consecutiveWin,
    this.consecutiveLogin,
  });

  factory UserModel.fromJson(Map<dynamic, dynamic> json) {
    return UserModel(
      id: json['id'] as String ?? '',
      email: json['email'] as String ?? '',
      name: json['name'] as String ?? '',
      address: json['address'] as String ?? '',
      age: json['age'] as num ?? 0,
      consecutiveWin: json['consecutiveWin'] as num ?? 0,
      consecutiveLogin: json['consecutiveLogin'] as num ?? 0,
      createdAt: (json['createdAt'] as Timestamp).toDate() ?? DateTime.now(),
      image: json['image'] as String ?? '',
      isAdmin: json['isAdmin'] as bool ?? false,
      isFacebookUser: json['isFacebookUser'] as bool ?? false,
      isLoggedIn: json['isLoggedIn'] as bool ?? false,
      level: json['level'] as num ?? 1,
      location: json['location'] as String ?? '',
      loginAt: (json['loginAt'] as Timestamp).toDate() ?? DateTime.now(),
      notification: json['notification'] as bool ?? false,
      points: json['points'] as num ?? 0,
      profession: json['profession'] as String ?? '',
      rewardsAt: (json['rewardsAt'] as Timestamp).toDate() ?? DateTime.now(),
      totalAccept: json['totalAccept'] as num ?? 0,
      totalAccepted: json['totalAccepted'] as num ?? 0,
      totalChallenge: json['totalChallenge'] as num ?? 0,
      totalGamePlayed: json['totalGamePlayed'] as num ?? 0,
      totalDecline: json['totalDecline'] as num ?? 0,
      totalDeclined: json['totalDeclined'] as num ?? 0,
      totalLoss: json['totalLoss'] as num ?? 0,
      totalPlayed: json['totalPlayed'] as num ?? 0,
      totalRequest: json['totalRequest'] as num ?? 0,
      totalWin: json['totalWin'] as num ?? 0,
      updatedAt: (json['updatedAt'] as Timestamp).toDate() ?? DateTime.now(),
      userType: json['userType'] as String ?? '',
    );
  }

  Map<String, dynamic> toJson() => _userModelToJson(this);

  @override
  String toString() => "FirebaseUser <$name>";


  Map<String, dynamic> _userModelToJson(UserModel instance) =>
      <String, dynamic> {
        'id': instance.id ?? '',
        'email': instance.email ?? '',
        'profession': instance.profession ?? '',
        'deviceToken': instance.deviceToken ?? '',
        'facebookId': instance.facebookId ?? '',
        'name': instance.name ?? '',
        'image': instance.image ?? '',
        'userType': instance.userType ?? '',
        'age': instance.age ?? 0,
        'isFacebookUser': instance.isFacebookUser ?? false,
        'isLoggedIn': instance.isLoggedIn ?? false,
        'notification': instance.notification ?? false,
        'address': instance.address ?? '',
        'location': instance.location ?? '',
        'totalChallenge': instance.totalChallenge ?? 0,
        'totalGamePlayed': instance.totalGamePlayed ?? 0,
        'totalDecline': instance.totalDecline ?? 0,
        'totalAccept': instance.totalAccept ?? 0,
        'totalWin': instance.totalWin ?? 0,
        'totalRequest': instance.totalRequest ?? 0,
        'totalPlayed': instance.totalPlayed ?? 0,
        'totalLoss': instance.totalLoss ?? 0,
        'totalAccepted': instance.totalAccepted ?? 0,
        'totalDeclined': instance.totalDeclined ?? 0,
        'points': instance.points ?? 0,
        'level': instance.level ?? 1,
        'isAdmin': instance.isAdmin ?? false,
        'rewardsAt': Timestamp.fromDate(instance.rewardsAt ?? DateTime.now()),
        'createdAt': Timestamp.fromDate(instance.createdAt ?? DateTime.now()),
        'updatedAt': Timestamp.fromDate(instance.updatedAt ?? DateTime.now()),
        'loginAt': Timestamp.fromDate(instance.loginAt ?? DateTime.now()),
        'consecutiveWin': instance.consecutiveWin ?? 0,
        'consecutiveLogin': instance.consecutiveLogin ?? 0,
      };

}