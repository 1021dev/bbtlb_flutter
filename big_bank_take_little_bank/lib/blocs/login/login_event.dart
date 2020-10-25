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

class LinkAccountEvent extends LoginScreenEvent {
  final String email;
  final String password;
  final String provider;
  final AuthCredential credential;
  final String linkProvider;

  LinkAccountEvent({this.email, this.password, this.provider, this.credential, this.linkProvider});
}

class RegisterUserProfileEvent extends LoginScreenEvent {

  final String id;
  final UserCredential credential;

  RegisterUserProfileEvent({this.id, this.credential});
}