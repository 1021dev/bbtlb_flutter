import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

class ForgetPasswordEvent extends LoginScreenEvent {
  final String email;
  ForgetPasswordEvent({this.email});
}

class SignInWithGoogleEvent extends LoginScreenEvent {

}

class SignInWithFacebookEvent extends LoginScreenEvent {
}

class SignInWithTwitterEvent extends LoginScreenEvent {

}

class SignInWithAppleEvent extends LoginScreenEvent {

}
class RegisterUserProfileEvent extends LoginScreenEvent {

  final UserCredential credential;

  RegisterUserProfileEvent({this.credential});
}