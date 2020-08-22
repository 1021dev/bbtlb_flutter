import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ProfileScreenState extends Equatable {
  final bool isLoading;
  final UserModel currentUser;

  ProfileScreenState({
    this.isLoading = false,
    this.currentUser,
  });

  @override
  List<Object> get props => [
    isLoading,
    currentUser,
  ];

  ProfileScreenState copyWith({
    bool isLoading,
    UserModel currentUser,
  }) {
    return ProfileScreenState(
      isLoading: isLoading ?? this.isLoading,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}

class ProfileScreenSuccess extends ProfileScreenState {
  @override
  ProfileScreenState copyWith({bool isLoading, UserModel currentUser}) {
    ProfileScreenSuccess(
      isLoading: isLoading ?? this.isLoading,
      currentUser: currentUser ?? this.currentUser,
    );
    return super.copyWith(isLoading: false, currentUser: currentUser);
  }
  final bool isLoading;
  final UserModel currentUser;

  ProfileScreenSuccess({
    this.isLoading = false,
    this.currentUser,
  });

  @override
  List<Object> get props => [
    isLoading,
    currentUser,
  ];

}

class UploadProfileImageSuccess extends ProfileScreenState {
  @override
  ProfileScreenState copyWith({bool isLoading, UserModel currentUser}) {

    return super.copyWith(isLoading: false, currentUser: currentUser);
  }
}

class ProfileScreenFailure extends ProfileScreenState {
  final String error;

  ProfileScreenFailure({@required this.error}) : super();

  @override
  ProfileScreenState copyWith({bool isLoading, UserModel currentUser}) {
    return super.copyWith(isLoading: false, currentUser: currentUser);
  }

  @override
  String toString() => 'ProfileScreenFailure { error: $error }';
}

class ProfileScreenLogout extends ProfileScreenState {}
