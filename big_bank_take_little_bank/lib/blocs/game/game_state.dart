import 'package:big_bank_take_little_bank/models/challenge_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:equatable/equatable.dart';

class GameState extends Equatable {
  final bool isLoading;
  final ChallengeModel challengeModel;
  final DateTime dateTime;

  GameState({
    this.isLoading = false,
    this.challengeModel,
    this.dateTime,
  });

  @override
  List<Object> get props => [
    isLoading,
    challengeModel,
    dateTime,
  ];
  GameState copyWith({
    bool isLoading,
    ChallengeModel challengeModel,
    DateTime dateTime,
  }) {
    return GameState(
      isLoading: isLoading ?? this.isLoading,
      challengeModel: challengeModel,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}

class GameInState extends GameState {
  final ChallengeModel challengeModel;
  final UserModel userModel;
  final DateTime startTime;

  GameInState({this.challengeModel, this.userModel, this.startTime,});

  @override
  List<Object> get props => [
    challengeModel,
    userModel,
    startTime,
  ];
  GameState copyWith({
    bool isLoading,
    ChallengeModel challengeModel,
    UserModel userModel,
    DateTime dateTime,
  }) {
    return GameInState(
      userModel: userModel,
      challengeModel: challengeModel,
      startTime: dateTime ?? this.startTime,
    );
  }

}

class GameDeclinedState extends GameState {
  final ChallengeModel challengeModel;

  GameDeclinedState({this.challengeModel});

  @override
  List<Object> get props => [
    challengeModel,
  ];

}

class GameNotAnsweredState extends GameState {
  final ChallengeModel challengeModel;

  GameNotAnsweredState({this.challengeModel});

  @override
  List<Object> get props => [
    challengeModel,
  ];

}

class GameRequestedState extends GameState {
  final ChallengeModel challengeModel;

  GameRequestedState({this.challengeModel});

  @override
  List<Object> get props => [
    challengeModel,
  ];

}

class GameCanceledState extends GameState {
  final ChallengeModel challengeModel;

  GameCanceledState({this.challengeModel});

  @override
  List<Object> get props => [
    challengeModel,
  ];

}

class GameResultState extends GameState {
  final ChallengeModel challengeModel;
  final UserModel userModel;

  GameResultState({this.challengeModel, this.userModel});

  @override
  List<Object> get props => [
    challengeModel,
  ];
  GameState copyWith({
    bool isLoading,
    ChallengeModel challengeModel,
    UserModel userModel,
    DateTime dateTime,
  }) {
    return GameResultState(
      userModel: userModel,
      challengeModel: challengeModel,
    );
  }

}