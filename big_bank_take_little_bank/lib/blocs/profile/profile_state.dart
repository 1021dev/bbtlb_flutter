import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contact/contacts.dart';

class ProfileScreenState extends Equatable {
  final bool isLoading;
  final UserModel currentUser;
  final List<Contact> contacts;

  ProfileScreenState({
    this.isLoading = false,
    this.currentUser,
    this.contacts = const [],
  });

  @override
  List<Object> get props => [
    isLoading,
    currentUser,
    contacts,
  ];

  ProfileScreenState copyWith({
    bool isLoading,
    UserModel currentUser,
    List<Contact> contacts,
  }) {
    return ProfileScreenState(
      isLoading: isLoading ?? this.isLoading,
      currentUser: currentUser ?? this.currentUser,
      contacts: contacts ?? this.contacts,
    );
  }
}

class ProfileScreenSuccess extends ProfileScreenState {
  @override
  ProfileScreenState copyWith({
    bool isLoading,
    UserModel currentUser,
    List<Contact> contacts,
  }) {
    ProfileScreenSuccess(
      isLoading: isLoading ?? this.isLoading,
      currentUser: currentUser ?? this.currentUser,
      contacts: contacts ?? this.contacts,
    );

    return super.copyWith(
        isLoading: false,
        currentUser: currentUser,
        contacts: contacts,
    );
  }
  final bool isLoading;
  final UserModel currentUser;
  final List<Contact> contacts;

  ProfileScreenSuccess({
    this.isLoading = false,
    this.currentUser,
    this.contacts = const [],
  });

  @override
  List<Object> get props => [
    isLoading,
    currentUser,
    contacts,
  ];

}

class UploadProfileImageSuccess extends ProfileScreenState {
}

class ProfileScreenFailure extends ProfileScreenState {
  final String error;

  ProfileScreenFailure({@required this.error}) : super();

  @override
  String toString() => 'ProfileScreenFailure { error: $error }';
}

class ProfileScreenLogout extends ProfileScreenState {}
class UpdatePasswordSuccess extends ProfileScreenState {}
