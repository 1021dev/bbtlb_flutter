import 'package:big_bank_take_little_bank/models/challenge_model.dart';
import 'package:equatable/equatable.dart';

class GameState extends Equatable {
  final bool isLoading;
  final ChallengeModel challengeModel;

  GameState({
    this.isLoading = false,
    this.challengeModel,
  });

  @override
  List<Object> get props => [
    isLoading,
    challengeModel,
  ];
  GameState copyWith({
    bool isLoading,
    ChallengeModel challengeModel,
  }) {
    return GameState(
      isLoading: isLoading ?? this.isLoading,
      challengeModel: challengeModel ?? this.challengeModel,
    );
  }
}

class GameInState extends GameState {
  final ChallengeModel challengeModel;

  GameInState({this.challengeModel});

  @override
  List<Object> get props => [
    challengeModel,
  ];

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

  GameResultState({this.challengeModel});

  @override
  List<Object> get props => [
    challengeModel,
  ];

}