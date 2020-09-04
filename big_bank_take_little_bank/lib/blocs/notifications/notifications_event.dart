
import 'dart:io';

import 'package:big_bank_take_little_bank/models/block_model.dart';
import 'package:big_bank_take_little_bank/models/notification_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class NotificationScreenEvent extends Equatable {
  const NotificationScreenEvent();

  @override
  List<Object> get props => [];
}

@immutable
class NotificationInitEvent extends NotificationScreenEvent {
}

@immutable
class NotificationsLoadedEvent extends NotificationScreenEvent {
  final List<NotificationModel> notificationsList;

  NotificationsLoadedEvent({this.notificationsList,});
}

@immutable
class DeleteNotificationEvent extends NotificationScreenEvent {
  final NotificationModel notificationModel;
  DeleteNotificationEvent({this.notificationModel});
}

class ReadNotificationEvent extends NotificationScreenEvent {
  final NotificationModel notificationModel;
  ReadNotificationEvent({this.notificationModel});
}

