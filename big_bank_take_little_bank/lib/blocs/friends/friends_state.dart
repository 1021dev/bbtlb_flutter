import 'package:big_bank_take_little_bank/models/friends_model.dart';
import 'package:big_bank_take_little_bank/models/rewards_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class FriendsState extends Equatable {

  FriendsState();

  @override
  List<Object> get props => [];
}

class FriendsInitState extends FriendsState {
  final bool isLoading;
  FriendsInitState({this.isLoading = false});
}

class FriendsLoadState extends FriendsState {
  final FriendsModel friendsModel;

  FriendsLoadState({
    this.friendsModel,
  });

  @override
  List<Object> get props => [
    friendsModel,
  ];
  FriendsLoadState copyWith({
    FriendsModel friendsModel,
  }) {
    return FriendsLoadState(
      friendsModel: friendsModel ?? this.friendsModel,
    );
  }
}

class FriendsListLoadState extends FriendsState {
  final List<FriendsModel> friendsList;

  FriendsListLoadState({
    this.friendsList,
  });

  @override
  List<Object> get props => [
    friendsList,
  ];
  FriendsListLoadState copyWith({
    List<FriendsModel> friendsList,
  }) {
    return FriendsListLoadState(
      friendsList: friendsList ?? this.friendsList,
    );
  }
}

class FriendsSuccess extends FriendsState {
  final FriendsModel friendsModel;

  FriendsSuccess({
    this.friendsModel,
  });

  @override
  List<Object> get props => [
    friendsModel,
  ];
  FriendsSuccess copyWith({
    FriendsModel friendsModel,
  }) {
    return FriendsSuccess(
      friendsModel: friendsModel ?? this.friendsModel,
    );
  }
}

class FriendsListSuccess extends FriendsState {
  final List<FriendsModel> friendsList;

  FriendsListSuccess({
    this.friendsList,
  });

  @override
  List<Object> get props => [
    friendsList,
  ];
  FriendsListSuccess copyWith({
    List<FriendsModel> friendsList,
  }) {
    return FriendsListSuccess(
      friendsList: friendsList ?? this.friendsList,
    );
  }
}

class FriendsFailure extends FriendsState {
  final String error;

  FriendsFailure({@required this.error}) : super();

  @override
  String toString() => 'FriendsFailure { error: $error }';
}

