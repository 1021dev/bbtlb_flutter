
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AuthScreenEvent extends Equatable {
  const AuthScreenEvent();

  @override
  List<Object> get props => [];
}


@immutable
class AuthScreenInitEvent extends AuthScreenEvent {}

@immutable
class AddAuthProfileImageEvent extends AuthScreenEvent {
  final File file;

  AddAuthProfileImageEvent({this.file});
}

@immutable
class RegisterUserEvent extends AuthScreenEvent {

  final String email;
  final String password;
  final String name;
  final String profession;
  final String location;
  final num age;
  final String image;
  RegisterUserEvent({
    this.email,
    this.password,
    this.name,
    this.profession,
    this.location,
    this.age,
    this.image,
  });
}
