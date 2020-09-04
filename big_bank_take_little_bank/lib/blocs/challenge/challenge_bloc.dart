import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/models/challenge_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:big_bank_take_little_bank/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class ChallengeBloc extends Bloc<ChallengeEvent, ChallengeState> {

  ChallengeBloc(ChallengeState initialState) : super(initialState);
  StreamSubscription _streamChallengeList;
  StreamSubscription _streamRequestedChallenges;
  StreamSubscription _streamReceivedChallenges;

  FriendsState get initialState {
    return FriendsInitState();
  }

  FirestoreService service = FirestoreService();

  @override
  Stream<ChallengeState> mapEventToState(ChallengeEvent event) async* {
    if (event is ChallengeInitEvent) {
      yield* loadInitChallenge();
    } else if (event is RequestChallengeEvent) {
      yield* requestChallenge(event.type, event.userModel, event.challengeTime);
    } else if (event is LoadedRequestedChallengeEvent) {
      if (event.challengeList.length > 0 || state.receivedRequestList.length > 0) {
        yield state.copyWith(isGamePlay: true, pendingRequestList: event.challengeList);
      } else {
        yield state.copyWith(isGamePlay: false, pendingRequestList: event.challengeList);
      }
    } else if (event is LoadedReceivedChallengeEvent) {
      if (event.challengeList.length > 0 || state.pendingRequestList.length > 0) {
         yield state.copyWith(isGamePlay: true, receivedRequestList: event.challengeList);
      } else {
        yield state.copyWith(isGamePlay: false, receivedRequestList: event.challengeList);
      }
    }
  }

  Stream<ChallengeState> requestChallenge(String type, UserModel userModel, double timeInterval) async* {

    yield state.copyWith(isRequesting: true);
    Map<String, String> body = {
      'receiver': userModel.id,
      'sender': Global.instance.userId,
      'type': type,
      'scheduleDate': '${timeInterval ?? 0}',
    };
    print('request challenge body => $body');
    http.Response response = await http.post(
      AppConstant.appChallengeUrl,
      body: jsonEncode(body),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
      }
    );
    if (response.body != null) {
      print(response.statusCode);
      print(response.body);
      dynamic decode = json.decode(response.body);
      print(decode);
    }
    yield state.copyWith(isRequesting: false);
  }

  Stream<ChallengeState> loadInitChallenge() async* {
    await _streamRequestedChallenges?.cancel();
    _streamRequestedChallenges = service.streamRequestedChallenge(Global.instance.userId).listen((event) {
      if (event.size > 0) {
        List<ChallengeModel> challenges = [];
        event.docs.forEach((element) {
          challenges.add(ChallengeModel.fromJson(element.data()));
        });
        add(LoadedRequestedChallengeEvent(challengeList: challenges));
      } else {
        add(LoadedRequestedChallengeEvent(challengeList: []));
      }
    });
    await _streamReceivedChallenges?.cancel();
    _streamReceivedChallenges = service.streamReceivedChallenge(Global.instance.userId).listen((event) {
      if (event.size > 0) {
        List<ChallengeModel> challenges = [];
        event.docs.forEach((element) {
          challenges.add(ChallengeModel.fromJson(element.data()));
        });
        add(LoadedReceivedChallengeEvent(challengeList: challenges));
      } else {
        add(LoadedReceivedChallengeEvent(challengeList: []));
      }
    });

  }


  @override
  Future<void> close() {
    _streamChallengeList?.cancel();
    _streamRequestedChallenges?.cancel();
    _streamReceivedChallenges?.cancel();
    return super.close();
  }

}