

import 'package:big_bank_take_little_bank/models/block_model.dart';
import 'package:big_bank_take_little_bank/models/friends_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class FriendsEvent extends Equatable {
  const FriendsEvent();

  @override
  List<Object> get props => [];
}

@immutable
class LoadFriends extends FriendsEvent {
  final String friendId;
  LoadFriends({this.friendId});
}

@immutable
class LoadOtherUserProfile extends FriendsEvent {
  final String friendId;
  LoadOtherUserProfile({this.friendId});
}

@immutable
class LoadedFriendsEvent extends FriendsEvent {
  final FriendsModel friendsModel;
  LoadedFriendsEvent({this.friendsModel});
}

@immutable
class LoadedBlockEvent extends FriendsEvent {
  final BlockModel blockModel;
  LoadedBlockEvent({this.blockModel});
}

@immutable
class LoadFriendsList extends FriendsEvent {}

@immutable
class LoadedFriendsListEvent extends FriendsEvent {
  final List<FriendsModel> friendsList;
  LoadedFriendsListEvent({this.friendsList});
}

@immutable
class LoadedRequestListEvent extends FriendsEvent {
  final List<FriendsModel> requestList;
  LoadedRequestListEvent({this.requestList});
}

class RequestFriends extends FriendsEvent {
  final UserModel userModel;
  RequestFriends({this.userModel});
}

@immutable
class AcceptFriends extends FriendsEvent {
  final FriendsModel friendsModel;

  AcceptFriends({this.friendsModel,});
}

@immutable
class DeclineFriends extends FriendsEvent {
  final FriendsModel friendsModel;

  DeclineFriends({this.friendsModel,});
}

@immutable
class BlockFriends extends FriendsEvent {
  final BlockModel blockModel;

  BlockFriends({this.blockModel,});
}
@immutable
class UnBlockFriends extends FriendsEvent {
  final BlockModel blockModel;

  UnBlockFriends({this.blockModel,});
}

@immutable
class CancelFriends extends FriendsEvent {
  final FriendsModel friendsModel;

  CancelFriends({this.friendsModel,});
}
