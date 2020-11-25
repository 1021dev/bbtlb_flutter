

import 'package:big_bank_take_little_bank/models/block_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../bloc.dart';

@immutable
abstract class MainScreenEvent extends Equatable {
  const MainScreenEvent();

  @override
  List<Object> get props => [];
}


@immutable
class MainScreenInitEvent extends MainScreenEvent {}

class MainScreenUserLoadedEvent extends MainScreenEvent {
  final UserModel user;
  MainScreenUserLoadedEvent({this.user});
}

class BlockListLoadedEvent extends MainScreenEvent {
  final List<BlockModel> blockList;
  BlockListLoadedEvent({this.blockList});
}

class MainScreenUsersLoadEvent extends MainScreenEvent {
  final List<UserModel> users;
  MainScreenUsersLoadEvent({this.users});
}

@immutable
class UpdateScreenEvent extends MainScreenEvent {
  final int screenIndex;

  UpdateScreenEvent({this.screenIndex,});
}

class LoadActiveUsersEvent extends MainScreenEvent {}

class UserLoginEvent extends MainScreenEvent {}

class UserOnlineEvent extends MainScreenEvent {}

class UserOfflineEvent extends MainScreenEvent {}

class SearchUserEvent extends MainScreenEvent {
  final String query;

  SearchUserEvent({this.query});
}

class ReceivedLocalNotificationEvent extends MainScreenEvent {
  final ReceivedNotification receivedNotification;
  ReceivedLocalNotificationEvent({this.receivedNotification});
}

class ShowAndroidNotificationsEvent extends MainScreenEvent {
  final dynamic notification;
  ShowAndroidNotificationsEvent({this.notification});
}
class ShowAndroidDataNotificationsEvent extends MainScreenEvent {
  final dynamic data;
  ShowAndroidDataNotificationsEvent({this.data});
}
