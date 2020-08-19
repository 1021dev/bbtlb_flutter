
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class LoginScreenEvent extends Equatable {
  const LoginScreenEvent();

  @override
  List<Object> get props => [];
}


@immutable
class LoginScreenInitEvent extends LoginScreenEvent {}

@immutable
class LoginUserEvent extends LoginScreenEvent {
  final String email;
  final String password;

  LoginUserEvent({this.email, this.password});
}
