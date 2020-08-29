import 'package:big_bank_take_little_bank/models/block_model.dart';
import 'package:big_bank_take_little_bank/models/friends_model.dart';
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
  final BlockModel blockModel;

  FriendsLoadState({
    this.friendsModel,
    this.userModel,
    this.blockModel,
  });

  @override
  List<Object> get props => [
    friendsModel,
    userModel,
    blockModel,
  ];
  FriendsLoadState copyWith({
    FriendsModel friendsModel,
    UserModel userModel,
    BlockModel blockModel,
  }) {
    return FriendsLoadState(
      friendsModel: friendsModel ?? this.friendsModel,
      userModel: userModel ?? this.userModel,
      blockModel: blockModel ?? this.blockModel,
    );
  }
}

class FriendsListLoadState extends FriendsState {
  final List<FriendsModel> friendsList;
  final List<BlockModel> blockList;
  final List<FriendsModel> requestList;
  final List<FriendsGroupModel> friendsGroupList;

  FriendsListLoadState({
    this.friendsList = const [],
    this.requestList = const [],
    this.friendsGroupList = const [],
    this.blockList = const [],
  });

  @override
  List<Object> get props => [
    friendsList,
    requestList,
    friendsGroupList,
    blockList,
  ];
  FriendsListLoadState copyWith({
    List<FriendsModel> friendsList,
    List<FriendsModel> requestList,
    List<FriendsGroupModel> friendsGroupList,
    List<BlockModel> blockList,
  }) {
    return FriendsListLoadState(
      friendsList: friendsList ?? this.friendsList,
      requestList: requestList ?? this.requestList,
      friendsGroupList: friendsGroupList ?? this.friendsGroupList,
      blockList: blockList ?? this.blockList,
    );
  }
}

class FriendsSuccess extends FriendsState {
  final FriendsModel friendsModel;
  final UserModel userModel;
  final BlockModel blockModel;

  FriendsSuccess({
    this.friendsModel,
    this.userModel,
    this.blockModel,
  });

  @override
  List<Object> get props => [
    friendsModel,
    userModel,
    blockModel,
  ];
  FriendsSuccess copyWith({
    FriendsModel friendsModel,
    UserModel userModel,
    BlockModel blockModel,
  }) {
    return FriendsSuccess(
      friendsModel: friendsModel ?? this.friendsModel,
      userModel: userModel ?? this.userModel,
      blockModel: blockModel ?? this.blockModel,
    );
  }
}

class FriendsListSuccess extends FriendsState {
  final List<FriendsModel> friendsList;
  final List<BlockModel> blockList;
  final List<FriendsModel> requestList;
  final List<FriendsGroupModel> friendsGroupList;

  FriendsListSuccess({
    this.friendsList = const [],
    this.requestList = const [],
    this.friendsGroupList = const [],
    this.blockList = const [],
  });

  @override
  List<Object> get props => [
    friendsList,
    requestList,
    friendsGroupList,
    blockList,
  ];
  FriendsListSuccess copyWith({
    List<FriendsModel> friendsList,
    List<FriendsModel> requestList,
    List<FriendsGroupModel> friendsGroupList,
    List<BlockModel> blockList,
  }) {
    return FriendsListSuccess(
      friendsList: friendsList ?? this.friendsList,
      requestList: requestList ?? this.requestList,
      friendsGroupList: friendsGroupList ?? this.friendsGroupList,
      blockList: blockList ?? this.blockList,
    );
  }
}

class FriendsFailure extends FriendsState {
  final String error;

  FriendsFailure({@required this.error}) : super();

  @override
  String toString() => 'FriendsFailure { error: $error }';
}

