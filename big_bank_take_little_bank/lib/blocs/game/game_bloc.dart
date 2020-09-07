import 'dart:async';

import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/models/challenge_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameBloc extends Bloc<GameEvent, GameState> {

  GameBloc(GameState initialState) : super(initialState);
  StreamSubscription _streamChallengeList;
  StreamSubscription _streamRequestedChallenges;
  StreamSubscription _streamReceivedChallenges;
  StreamSubscription _streamCurrentChallenge;

  GameState get initialState {
    return GameState();
  }

  FirestoreService service = FirestoreService();

  @override
  Stream<GameState> mapEventToState(GameEvent event) async* {
    if (event is GameInEvent) {
      if (event.userModel != null) {
        yield GameInState(
            challengeModel: event.challengeModel, userModel: event.userModel);
      } else {
        yield* getGameResult(event.challengeModel);
      }
    } else if (event is GameAcceptEvent) {
      if (event.userModel != null) {
        yield GameInState(
            challengeModel: event.challengeModel, userModel: event.userModel);
      } else {
        yield* getGameResult(event.challengeModel);
      }
    } else if (event is ChallengeDeclinedEvent) {
      yield GameDeclinedState(challengeModel: event.challengeModel);
    } else if (event is ChallengeNoAnsweredEvent) {
      yield GameNotAnsweredState(challengeModel: event.challengeModel);
    } else if (event is ChallengeCancelledEvent) {
      yield GameCanceledState(challengeModel: event.challengeModel);
    } else if (event is GameResultEvent) {
      final currentState = state;
      if (currentState is GameInState) {
        yield GameResultState(challengeModel: currentState.challengeModel, userModel: currentState.userModel);
      }
    } else if (event is GameRequestedEvent) {
      yield* gameRequested(event.challengeModel);
    }
  }

  Stream<GameState> gameRequested(ChallengeModel challengeModel) async* {
    yield GameRequestedState(challengeModel: challengeModel);
  }

  Stream<GameState> getGameResult(ChallengeModel challengeModel) async* {
    String challengerUd = challengeModel.sender == Global.instance.userId ? challengeModel.receiver: challengeModel.sender;
    UserModel challenger = await FirestoreService().getUserWithId(challengerUd);
    yield GameInState(challengeModel: challengeModel, userModel: challenger);
  }

  @override
  Future<void> close() {
    _streamChallengeList?.cancel();
    _streamRequestedChallenges?.cancel();
    _streamReceivedChallenges?.cancel();
    _streamCurrentChallenge?.cancel();
    return super.close();
  }

}