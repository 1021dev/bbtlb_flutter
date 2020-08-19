import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreenState extends Equatable {
  final bool isLoading;
  final String password;
  final String email;

  LoginScreenState({
    this.isLoading = false,
    this.password,
    this.email,
  });

  @override
  List<Object> get props => [
    isLoading,
    email,
    password,
  ];

  LoginScreenState copyWith({
    bool isLoading,
    String password,
    String email,
  }) {
    return LoginScreenState(
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}

class LoginScreenSuccess extends LoginScreenState {}

class LoginScreenFailure extends LoginScreenState {
  final String error;

  LoginScreenFailure({@required this.error}) : super();

  @override
  String toString() => 'LoginScreenFailure { error: $error }';
}

