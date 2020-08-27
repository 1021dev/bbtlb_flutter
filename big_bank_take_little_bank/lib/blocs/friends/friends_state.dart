import 'package:big_bank_take_little_bank/models/friends_model.dart';
import 'package:big_bank_take_little_bank/models/rewards_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class FriendsState extends Equatable {

  FriendsState();

  @override
  List<Object> get props => [];
}

class FriendsInitState extends FriendsState {
  final bool isLoading;
  final UserModel userModel;
  FriendsInitState({this.isLoading = false, this.userModel});
}

class FriendsLoadState extends FriendsState {
  final FriendsModel friendsModel;
  final UserModel userModel;

  FriendsLoadState({
    this.friendsModel,
    this.userModel,
  });

  @override
  List<Object> get props => [
    friendsModel,
    userModel,
  ];
  FriendsLoadState copyWith({
    FriendsModel friendsModel,
    UserModel userModel,
  }) {
    return FriendsLoadState(
      friendsModel: friendsModel ?? this.friendsModel,
      userModel: userModel ?? this.userModel,
    );
  }
}

class FriendsListLoadState extends FriendsState {
  final List<FriendsModel> friendsList;
  final List<FriendsModel> requestList;
  final List<FriendsGroupModel> friendsGroupList;

  FriendsListLoadState({
    this.friendsList = const [],
    this.requestList = const [],
    this.friendsGroupList = const [],
  });

  @override
  List<Object> get props => [
    friendsList,
    requestList,
    friendsGroupList,
  ];
  FriendsListLoadState copyWith({
    List<FriendsModel> friendsList,
    List<FriendsModel> requestList,
    List<FriendsGroupModel> friendsGroupList,
  }) {
    return FriendsListLoadState(
      friendsList: friendsList ?? this.friendsList,
      requestList: requestList ?? this.requestList,
      friendsGroupList: friendsGroupList ?? this.friendsGroupList,
    );
  }
}

class FriendsSuccess extends FriendsState {
  final FriendsModel friendsModel;
  final UserModel userModel;

  FriendsSuccess({
    this.friendsModel,
    this.userModel,
  });

  @override
  List<Object> get props => [
    friendsModel,
    userModel,
  ];
  FriendsSuccess copyWith({
    FriendsModel friendsModel,
    UserModel userModel,
  }) {
    return FriendsSuccess(
      friendsModel: friendsModel ?? this.friendsModel,
      userModel: userModel ?? this.userModel,
    );
  }
}

class FriendsListSuccess extends FriendsState {
  final List<FriendsModel> friendsList;
  final List<FriendsModel> requestList;
  final List<FriendsGroupModel> friendsGroupList;

  FriendsListSuccess({
    this.friendsList = const [],
    this.requestList = const [],
    this.friendsGroupList = const [],
  });

  @override
  List<Object> get props => [
    friendsList,
    requestList,
    friendsGroupList,
  ];
  FriendsListSuccess copyWith({
    List<FriendsModel> friendsList,
    List<FriendsModel> requestList,
    List<FriendsGroupModel> friendsGroupList,
  }) {
    return FriendsListSuccess(
      friendsList: friendsList ?? this.friendsList,
      requestList: requestList ?? this.requestList,
      friendsGroupList: friendsGroupList ?? this.friendsGroupList,
    );
  }
}

class FriendsFailure extends FriendsState {
  final String error;

  FriendsFailure({@required this.error}) : super();

  @override
  String toString() => 'FriendsFailure { error: $error }';
}

