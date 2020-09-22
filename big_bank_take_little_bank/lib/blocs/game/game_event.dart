import 'package:big_bank_take_little_bank/models/challenge_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

class GameInEvent extends GameEvent {
  final ChallengeModel challengeModel;
  final UserModel userModel;
  GameInEvent({this.challengeModel, this.userModel});
}

class GameAcceptEvent extends GameEvent {
  final ChallengeModel challengeModel;
  final UserModel userModel;
  GameAcceptEvent({this.challengeModel, this.userModel});
}

class GameResultEvent extends GameEvent {
  final ChallengeModel model;
  final UserModel userModel;
  GameResultEvent({this.model, this.userModel});
}

class GameRequestedEvent extends GameEvent {
  final ChallengeModel challengeModel;
  GameRequestedEvent({this.challengeModel});
}

class ChallengeDeclinedEvent extends GameEvent {
  final ChallengeModel challengeModel;
  ChallengeDeclinedEvent({this.challengeModel});
}

class ChallengeCancelledEvent extends GameEvent {
  final ChallengeModel challengeModel;
  ChallengeCancelledEvent({this.challengeModel});
}

class ChallengeNoAnsweredEvent extends GameEvent {
  final ChallengeModel challengeModel;
  ChallengeNoAnsweredEvent({this.challengeModel});
}