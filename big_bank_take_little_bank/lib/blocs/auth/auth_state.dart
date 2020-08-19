import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreenState extends Equatable {
  final bool isLoading;
  final String userName;
  final String password;
  final String email;
  final String profession;
  final String location;
  final num age;
  final String image;
  final File file;

  AuthScreenState({
    this.isLoading = false,
    this.userName,
    this.password,
    this.email,
    this.profession,
    this.age,
    this.location,
    this.image,
    this.file,
  });

  @override
  List<Object> get props => [
    isLoading,
    userName,
    email,
    password,
    profession,
    age,
    location,
    image,
    file,
  ];

  AuthScreenState copyWith({
    bool isLoading,
    String userName,
    String password,
    String email,
    String profession,
    String location,
    num age,
    String image,
    File file,
  }) {
    return AuthScreenState(
      isLoading: isLoading ?? this.isLoading,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      password: password ?? this.password,
      profession: profession ?? this.profession,
      location: location ?? this.location,
      age: age ?? this.age,
      image: image ?? this.image,
      file: file ?? this.file,
    );
  }
}

class AuthScreenSuccess extends AuthScreenState {}
class AuthEmailVerification extends AuthScreenState {}

class AuthScreenFailure extends AuthScreenState {
  final String error;

  AuthScreenFailure({@required this.error}) : super();

  @override
  String toString() => 'AuthScreenFailure { error: $error }';
}

