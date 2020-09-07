import 'package:big_bank_take_little_bank/models/challenge_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ChallengeEvent extends Equatable {
  const ChallengeEvent();

  @override
  List<Object> get props => [];
}

@immutable
class ChallengeInitEvent extends ChallengeEvent {}

@immutable
class LoadChallengeEvent extends ChallengeEvent {
  final String friendId;
  LoadChallengeEvent({this.friendId});
}

@immutable
class LoadUserProfile extends ChallengeEvent {
  final String friendId;
  LoadUserProfile({this.friendId});
}

@immutable
class LoadedChallengeListEvent extends ChallengeEvent {
  final List<ChallengeModel> challengeList;
  LoadedChallengeListEvent({this.challengeList});
}

@immutable
class LoadedRequestedChallengeEvent extends ChallengeEvent {
  final List<ChallengeModel> challengeList;
  LoadedRequestedChallengeEvent({this.challengeList});
}

@immutable
class LoadedReceivedChallengeEvent extends ChallengeEvent {
  final List<ChallengeModel> challengeList;
  LoadedReceivedChallengeEvent({this.challengeList});
}

@immutable
class RequestChallengeEvent extends ChallengeEvent {
  final String type;
  final double challengeTime;
  final UserModel userModel;
  RequestChallengeEvent({
    this.type,
    this.challengeTime = 0,
    this.userModel,
  });
}

@immutable
class ResponseChallengeRequestEvent extends ChallengeEvent {
  final ChallengeModel challengeModel;
  final UserModel userModel;
  final String response;
  ResponseChallengeRequestEvent({
    this.challengeModel,
    this.response,
    this.userModel,
  });
}
