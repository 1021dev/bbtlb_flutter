import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class MainScreenState extends Equatable {
  const MainScreenState();

  @override
  List<Object> get props => [];
}

class MainScreenLoadState extends MainScreenState {
  final bool isLoading;
  final int currentScreen;
  final UserModel currentUser;
  final List<UserModel> activeUsers;

  MainScreenLoadState({
    this.isLoading = false,
    this.currentScreen,
    this.currentUser,
    this.activeUsers = const [],
  });

  @override
  List<Object> get props => [
    isLoading,
    currentScreen,
    currentUser,
    activeUsers,
  ];

  MainScreenLoadState copyWith({
    bool isLoading,
    int currentScreen,
    UserModel currentUser,
    List<UserModel> activeUsers,
  }) {
    return MainScreenLoadState(
      isLoading: isLoading ?? this.isLoading,
      currentScreen: currentScreen ?? this.currentScreen,
      currentUser: currentUser ?? this.currentUser,
      activeUsers: activeUsers ?? this.activeUsers,
    );
  }
}

class MainScreenInitState extends MainScreenState {}

class MainScreenFailure extends MainScreenState {
  final String error;

  MainScreenFailure({@required this.error}) : super();

  @override
  String toString() => 'MainScreenFailure { error: $error }';
}

