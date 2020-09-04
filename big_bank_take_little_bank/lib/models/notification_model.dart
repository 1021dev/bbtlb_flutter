import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String id;
  String action;
  DateTime createdAt;
  bool isRead;
  String kind;
  String receiver;
  String reference;
  String sender;
  String senderName;
  String senderPhoto;
  String subType;
  String message;
  DateTime timestamp;
  DateTime updatedAt;

  NotificationModel({
    this.id,
    this.action,
    this.createdAt,
    this.isRead,
    this.kind,
    this.receiver,
    this.reference,
    this.sender,
    this.senderName,
    this.senderPhoto,
    this.subType,
    this.message,
    this.timestamp,
    this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<dynamic, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String ?? '',
      action: json['action'] as String ?? '',
      isRead: json['isRead'] as bool ?? false,
      kind: json['kind'] as String ?? '',
      receiver: json['receiver'] as String ?? '',
      reference: json['reference'] as String ?? '',
      sender: json['sender'] as String ?? '',
      senderName: json['senderName'] as String ?? '',
      senderPhoto: json['senderPhoto'] as String ?? '',
      subType: json['subType'] as String ?? '',
      message: json['message'] as String ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate() ?? DateTime.now(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate() ?? DateTime.now(),
      timestamp: (json['timestamp'] as Timestamp).toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => _notificationToJson(this);

  @override
  String toString() => "Notification  <$id>";


  Map<String, dynamic> _notificationToJson(NotificationModel instance) =>
      <String, dynamic> {
        'id': instance.id ?? '',
        'createdAt': Timestamp.fromDate(instance.createdAt ?? DateTime.now()),
        'updatedAt': Timestamp.fromDate(instance.updatedAt ?? DateTime.now()),
        'timestamp': Timestamp.fromDate(instance.timestamp ?? DateTime.now()),
        'action': instance.action ?? '',
        'isRead': instance.isRead ?? false,
        'kind': instance.kind ?? '',
        'receiver': instance.receiver ?? '',
        'reference': instance.reference ?? '',
        'sender': instance.sender ?? '',
        'message': instance.message ?? '',
        'senderName': instance.senderName ?? '',
        'senderPhoto': instance.senderPhoto ?? '',
        'subType': instance.subType ?? '',
      };

}