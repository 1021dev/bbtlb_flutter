import 'package:big_bank_take_little_bank/models/friends_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contact/contacts.dart';

class ProfileScreenState extends Equatable {
  final bool isLoading;
  final UserModel currentUser;
  final List<Contact> contacts;
  final List<FriendsModel> blockList;

  ProfileScreenState({
    this.isLoading = false,
    this.currentUser,
    this.contacts = const [],
    this.blockList = const [],
  });

  @override
  List<Object> get props => [
    isLoading,
    currentUser,
    contacts,
    blockList,
  ];

  ProfileScreenState copyWith({
    bool isLoading,
    UserModel currentUser,
    List<Contact> contacts,
    List<FriendsModel> blockList,
  }) {
    return ProfileScreenState(
      isLoading: isLoading ?? this.isLoading,
      currentUser: currentUser ?? this.currentUser,
      contacts: contacts ?? this.contacts,
      blockList: blockList ?? this.blockList,
    );
  }
}

class ProfileScreenSuccess extends ProfileScreenState {
  @override
  ProfileScreenState copyWith({
    bool isLoading,
    UserModel currentUser,
    List<Contact> contacts,
    List<FriendsModel> blockList,
  }) {
    ProfileScreenSuccess(
      isLoading: isLoading ?? this.isLoading,
      currentUser: currentUser ?? this.currentUser,
      contacts: contacts ?? this.contacts,
      blockList: blockList ?? this.blockList,
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
  final List<FriendsModel> blockList;
  ProfileScreenSuccess({
    this.isLoading = false,
    this.currentUser,
    this.contacts = const [],
    this.blockList = const [],
  });

  @override
  List<Object> get props => [
    isLoading,
    currentUser,
    contacts,
    blockList,
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
