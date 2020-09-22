import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/models/challenge_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:big_bank_take_little_bank/utils/app_constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class ChallengeBloc extends Bloc<ChallengeEvent, ChallengeState> {

  ChallengeBloc(ChallengeState initialState) : super(initialState);
  StreamSubscription _streamChallengeList;
  StreamSubscription _streamRequestedChallenges;
  StreamSubscription _streamReceivedChallenges;
  StreamSubscription _streamCurrentChallenge;
  StreamSubscription _streamSubscriptionLiveChallenge;
  StreamSubscription _streamSubscriptionLiveChallengeFinished;
  StreamSubscription _streamSubscriptionScheduleChallenge;
  StreamSubscription _streamSubscriptionScheduleChallengeRequest;

  ChallengeState get initialState {
    return ChallengeState();
  }

  FirestoreService service = FirestoreService();

  @override
  Stream<ChallengeState> mapEventToState(ChallengeEvent event) async* {
    if (event is ChallengeInitEvent) {
      yield* loadInitChallenge();
      yield* loadLiveChallenge();
    } else if (event is RequestChallengeEvent) {
      yield* requestChallenge(event.type, event.userModel, event.challengeTime);
    } else if (event is LoadedRequestedChallengeEvent) {
      if (event.challengeList.length > 0 || state.receivedRequestList.length > 0) {
        yield state.copyWith(isGamePlay: true, pendingRequestList: event.challengeList);
      } else {
        yield state.copyWith(isGamePlay: false, pendingRequestList: event.challengeList);
      }
      if (event.challengeList.length > 0) {
        if ((event.challengeList.first.id ?? '') != '') {
          yield* observerChallenge(event.challengeList.first);
        }
      }
    } else if (event is LoadedReceivedChallengeEvent) {
      if (event.challengeList.length > 0 || state.pendingRequestList.length > 0) {
         yield state.copyWith(isGamePlay: true, receivedRequestList: event.challengeList);
      } else {
        yield state.copyWith(isGamePlay: false, receivedRequestList: event.challengeList);
      }
      if (event.challengeList.length > 0) {
        if ((event.challengeList.first.id ?? '') != '') {
          // BlocProvider.of<GameBloc>(Global.instance.homeContext)..add(GameRequestedEvent(challengeModel: event.challengeList.first));
        }
      }
    } else if (event is ResponseChallengeRequestEvent) {
      yield* updateChallenge(event.challengeModel, event.response);
    } else if (event is LiveChallengeScreenInitEvent) {
      yield* loadLiveChallenge();
    } else if (event is LiveChallengeScreenLoadedEvent) {
      yield state.copyWith(liveChallengeList: event.liveChallengeList, liveChallengeResultList: event.liveChallengeResultList);
    } else if (event is ScheduleChallengeScreenLoadedEvent) {
      yield state.copyWith(scheduleChallengeList: event.scheduleChallengeList, scheduleChallengeRequestList: event.scheduleChallengeRequestList);
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

  Stream<ChallengeState> updateChallenge(ChallengeModel model, String status) async* {
    await service.updateChallenge(model.id, {'status': status, 'updatedAt': DateTime.now()});
    if (status == 'accept') {
      if (model.type == 'schedule') {
        yield* _scheduleNotification(model);
        // BlocProvider.of<GameBloc>(Global.instance.homeContext).add(GameInEvent(challengeModel: model));
      } else {
        BlocProvider.of<GameBloc>(Global.instance.homeContext).add(GameInEvent(challengeModel: model));
      }
    }
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

  Stream<ChallengeState> observerChallenge(ChallengeModel challengeModel) async* {
    print('observer =================');
    await _streamCurrentChallenge?.cancel();
    _streamCurrentChallenge = service.streamChallenge(Global.instance.userId, challengeModel.id).listen((event) {
      print(event);
      if (event != null) {
        ChallengeModel model = ChallengeModel.fromJson(event.data());
        if (model.status == 'accept') {
          BlocProvider.of<GameBloc>(Global.instance.homeContext).add(GameInEvent(challengeModel: model));
          _streamCurrentChallenge.cancel();
        } else if (model.status == 'decline') {
          BlocProvider.of<GameBloc>(Global.instance.homeContext).add(ChallengeDeclinedEvent(challengeModel: model));
          _streamCurrentChallenge.cancel();
        } else if (model.status == 'notAnswered') {
          BlocProvider.of<GameBloc>(Global.instance.homeContext).add(ChallengeNoAnsweredEvent(challengeModel: model));
          _streamCurrentChallenge.cancel();
        } else if (model.status == 'cancel') {
          BlocProvider.of<GameBloc>(Global.instance.homeContext).add(ChallengeCancelledEvent(challengeModel: model));
          _streamCurrentChallenge.cancel();
        }
      }
    });
  }

  Stream<ChallengeState> loadLiveChallenge() async* {
    await _streamSubscriptionLiveChallenge?.cancel();
    _streamSubscriptionLiveChallenge = service.streamLiveChallenge(Global.instance.userId).listen((event) {
      if (event.size > 0) {
        List<ChallengeModel> liveChallenges = [];
        List<ChallengeModel> liveChallengesFinished = [];
        event.docs.forEach((element) {
          ChallengeModel challengeModel = ChallengeModel.fromJson(element.data());
          if (challengeModel.status == 'accept') {
            liveChallenges.add(challengeModel);
          } else if (challengeModel.status == 'completed') {
            liveChallengesFinished.add(challengeModel);
          }
        });
        add(LiveChallengeScreenLoadedEvent(liveChallengeList: liveChallenges, liveChallengeResultList: liveChallengesFinished));
      } else {
        add(LiveChallengeScreenLoadedEvent(liveChallengeList: [], liveChallengeResultList: []));
      }
    });
    await _streamSubscriptionScheduleChallenge?.cancel();
    _streamSubscriptionScheduleChallenge = service.streamScheduleChallenges(Global.instance.userId).listen((event) {
      if (event.size > 0) {
        List<ChallengeModel> scheduleChallenges = [];
        List<ChallengeModel> scheduleChallengesRequest = [];
        event.docs.forEach((element) {
          ChallengeModel challengeModel = ChallengeModel.fromJson(element.data());
          if (challengeModel.sender == Global.instance.userId || challengeModel.receiver == Global.instance.userId) {
            if (challengeModel.receiver == Global.instance.userId) {
              if (challengeModel.status == 'pending') {
                scheduleChallenges.add(challengeModel);
              }
            }
            if (challengeModel.status == 'accept') {
              scheduleChallengesRequest.add(challengeModel);
            }

          }
        });
        add(ScheduleChallengeScreenLoadedEvent(scheduleChallengeList: scheduleChallenges, scheduleChallengeRequestList: scheduleChallengesRequest));
      } else {
        add(ScheduleChallengeScreenLoadedEvent(scheduleChallengeList: [], scheduleChallengeRequestList: []));
      }
    });
  }

  /// Schedules a notification that specifies a different icon, sound and vibration pattern
  Stream<ChallengeState> _scheduleNotification(ChallengeModel challengeModel) async* {
    var scheduledNotificationDateTime =
    challengeModel.challengeTime.subtract(Duration(minutes: 1));
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description',
        icon: 'ic_launcher',
        sound: RawResourceAndroidNotificationSound('slow_spring_board'),
        vibrationPattern: vibrationPattern,
        enableLights: true,
        ledOnMs: 1000,
        ledOffMs: 500);
    var iOSPlatformChannelSpecifics =
    IOSNotificationDetails(sound: 'slow_spring_board.aiff');
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'You have schedule challenge at ',
        'scheduled body',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

  @override
  Future<void> close() {
    _streamChallengeList?.cancel();
    _streamRequestedChallenges?.cancel();
    _streamReceivedChallenges?.cancel();
    _streamCurrentChallenge?.cancel();
    _streamSubscriptionLiveChallenge?.cancel();
    _streamSubscriptionLiveChallengeFinished?.cancel();
    _streamSubscriptionScheduleChallenge?.cancel();
    _streamSubscriptionScheduleChallengeRequest?.cancel();
    return super.close();
  }

}