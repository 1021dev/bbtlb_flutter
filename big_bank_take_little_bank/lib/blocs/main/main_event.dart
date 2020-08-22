
import 'dart:io';

import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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

@immutable
class UpdateScreenEvent extends MainScreenEvent {
  final int screenIndex;

  UpdateScreenEvent({this.screenIndex,});
}
