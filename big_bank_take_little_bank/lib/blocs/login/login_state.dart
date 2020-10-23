import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LoginScreenState extends Equatable {
  final bool isLoading;
  final String password;
  final String email;
  final int socialRequest;

  LoginScreenState({
    this.isLoading = false,
    this.password,
    this.email,
    this.socialRequest,
  });

  @override
  List<Object> get props => [
    isLoading,
    email,
    password,
    socialRequest,
  ];

  LoginScreenState copyWith({
    bool isLoading,
    String password,
    String email,
    int socialRequest,
  }) {
    return LoginScreenState(
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      password: password ?? this.password,
      socialRequest: socialRequest ?? this.socialRequest,
    );
  }
}

class LoginScreenSuccess extends LoginScreenState {}

class LoginScreenPasswordResetSent extends LoginScreenState {}

class LoginScreenFailure extends LoginScreenState {
  final String error;

  LoginScreenFailure({@required this.error}) : super();

  @override
  String toString() => 'LoginScreenFailure { error: $error }';
}

