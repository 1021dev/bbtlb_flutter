import 'package:big_bank_take_little_bank/models/notification_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class NotificationScreenState extends Equatable {
  final bool isLoading;
  final List<NotificationModel> notifications;
  final List<NotificationModel> unreadNotifications;

  NotificationScreenState({
    this.isLoading = false,
    this.notifications = const [],
    this.unreadNotifications = const [],
  });

  @override
  List<Object> get props => [
    isLoading,
    notifications,
    unreadNotifications,
  ];

  NotificationScreenState copyWith({
    bool isLoading,
    List<NotificationModel> notifications,
    List<NotificationModel> unreadNotifications,
  }) {
    return NotificationScreenState(
      isLoading: isLoading ?? this.isLoading,
      notifications: notifications ?? this.notifications,
      unreadNotifications: unreadNotifications ?? this.unreadNotifications,
    );
  }
}

class NotificationScreenFailure extends NotificationScreenState {
  final String error;

  NotificationScreenFailure({@required this.error}) : super();

  @override
  String toString() => 'NotificationScreenFailure { error: $error }';
}

class NotificationScreenSuccess extends NotificationScreenState {}
