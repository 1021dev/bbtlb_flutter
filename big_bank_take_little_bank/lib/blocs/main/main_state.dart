import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainScreenState extends Equatable {
  final bool isLoading;
  final int currentScreen;
  final UserModel currentUser;

  MainScreenState({
    this.isLoading = false,
    this.currentScreen,
    this.currentUser,
  });

  @override
  List<Object> get props => [
    isLoading,
    currentScreen,
    currentUser,
  ];

  MainScreenState copyWith({
    bool isLoading,
    int currentScreen,
    UserModel currentUser,
  }) {
    return MainScreenState(
      isLoading: isLoading ?? this.isLoading,
      currentScreen: currentScreen ?? this.currentScreen,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}

class MainScreenSuccess extends MainScreenState {}

class MainScreenFailure extends MainScreenState {
  final String error;

  MainScreenFailure({@required this.error}) : super();

  @override
  String toString() => 'MainScreenFailure { error: $error }';
}

