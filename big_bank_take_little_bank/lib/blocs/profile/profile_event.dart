
import 'dart:io';

import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ProfileScreenEvent extends Equatable {
  const ProfileScreenEvent();

  @override
  List<Object> get props => [];
}


@immutable
class ProfileScreenInitEvent extends ProfileScreenEvent {
}

@immutable
class UpdateProfileScreenEvent extends ProfileScreenEvent {
  final UserModel userModel;

  UpdateProfileScreenEvent({this.userModel,});
}

@immutable
class ProfileScreenUserLoadedEvent extends ProfileScreenEvent {
  final UserModel user;
  ProfileScreenUserLoadedEvent({this.user});
}

class UploadProfileImageEvent extends ProfileScreenEvent {
  final File image;
  UploadProfileImageEvent({this.image});
}

class ProfileScreenLogoutEvent extends ProfileScreenEvent{}

class GetContactsEvent extends ProfileScreenEvent{}

class SendInviteFriendsEvent extends ProfileScreenEvent{}

class UpdatePasswordEvent extends ProfileScreenEvent {
  final String oldPassword;
  final String newPassword;

  UpdatePasswordEvent({this.newPassword, this.oldPassword});
}

class GetBlockListEvent extends ProfileScreenEvent{}

class UpdateNotificationSetting extends ProfileScreenEvent{
  final bool isNotification;
  UpdateNotificationSetting({this.isNotification = false});
}
