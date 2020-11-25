import 'package:big_bank_take_little_bank/models/block_model.dart';
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
  final List<UserModel> filterUsers;
  final List<BlockModel> blockList;

  MainScreenLoadState({
    this.isLoading = false,
    this.currentScreen,
    this.currentUser,
    this.activeUsers = const [],
    this.filterUsers = const [],
    this.blockList = const [],
  });

  @override
  List<Object> get props => [
    isLoading,
    currentScreen,
    currentUser,
    activeUsers,
    filterUsers,
    blockList,
  ];

  MainScreenLoadState copyWith({
    bool isLoading,
    int currentScreen,
    UserModel currentUser,
    List<UserModel> activeUsers,
    List<UserModel> filterUsers,
    List<BlockModel> blockList,
  }) {
    return MainScreenLoadState(
      isLoading: isLoading ?? this.isLoading,
      currentScreen: currentScreen ?? this.currentScreen,
      currentUser: currentUser ?? this.currentUser,
      activeUsers: activeUsers ?? this.activeUsers,
      filterUsers: filterUsers ?? this.filterUsers,
      blockList: blockList ?? this.blockList,
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

