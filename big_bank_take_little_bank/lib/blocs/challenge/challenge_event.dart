import 'package:big_bank_take_little_bank/models/challenge_model.dart';
import 'package:big_bank_take_little_bank/models/message_model.dart';
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

class LiveChallengeScreenInitEvent extends ChallengeEvent {}

class LiveChallengeScreenLoadedEvent extends ChallengeEvent {
  final List<ChallengeModel> liveChallengeList;
  final List<ChallengeModel> liveChallengeResultList;

  LiveChallengeScreenLoadedEvent({
    this.liveChallengeList,
    this.liveChallengeResultList,
  });
}

class ScheduleChallengeScreenLoadedEvent extends ChallengeEvent {
  final List<ChallengeModel> scheduleChallengeList;
  final List<ChallengeModel> scheduleChallengeResultList;

  ScheduleChallengeScreenLoadedEvent({
    this.scheduleChallengeList,
    this.scheduleChallengeResultList,
  });
}

class ShowChatEvent extends ChallengeEvent {
  final ChallengeModel selectedChallenge;
  ShowChatEvent({this.selectedChallenge});
}

class HideChatEvent extends ChallengeEvent {
  final ChallengeModel selectedChallenge;
  HideChatEvent({this.selectedChallenge});
}

class LoadChallengeChatEvent extends ChallengeEvent{
  final List<MessageModel> privateMessages;
  final List<MessageModel> publicMessage;

  LoadChallengeChatEvent({this.privateMessages, this.publicMessage});
}

class SendChallengeMessageEvent extends ChallengeEvent {
  final String message;
  final String userId;
  final String userName;
  final String userImage;
  final String type;

  SendChallengeMessageEvent({
    this.message,
    this.userId,
    this.userName,
    this.userImage,
    this.type,
  });
}

class UpdateCurrentChallengeEvent extends ChallengeEvent {
  final ChallengeModel challengeModel;

  UpdateCurrentChallengeEvent({this.challengeModel});
}