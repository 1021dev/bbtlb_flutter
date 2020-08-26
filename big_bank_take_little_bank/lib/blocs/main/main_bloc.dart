import 'dart:async';

import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/my_app.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:big_bank_take_little_bank/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {

  MainScreenBloc(MainScreenState initialState) : super(initialState);

  StreamSubscription _userSubscription;
  StreamSubscription _usersSubScription;

  MainScreenState get initialState {
    return MainScreenInitState();
  }

  FirestoreService service = FirestoreService();

  @override
  Stream<MainScreenState> mapEventToState(MainScreenEvent event) async* {
    if (event is MainScreenInitEvent) {
      yield* init();
    } else if (event is UpdateScreenEvent) {
      yield* toggleTab(event.screenIndex);
    } else if (event is MainScreenUserLoadedEvent) {
      if (state is MainScreenLoadState) {
        yield* reloadUser(event.user);
      } else {
        yield MainScreenLoadState(currentUser: event.user);
      }
    } else if (event is MainScreenUsersLoadEvent) {
      yield* reloadHomeScreen(event.users);
    }
  }

  Stream<MainScreenState> init() async* {
    User user = auth.currentUser;
    await _userSubscription?.cancel();
    _userSubscription = service.streamUser(user.uid).listen((event) {
      if (event != null) {
        Global.instance.userId = user.uid;
        Global.instance.userModel = event;
        add(MainScreenUserLoadedEvent(user: event));;
      }
    });
    await _usersSubScription?.cancel();
    _usersSubScription = service.streamUsers().listen((event) {
      if (event != null) {
        add(MainScreenUsersLoadEvent(users: event));;
      }
    });
  }

  Stream<MainScreenState> toggleTab(int index) async* {
    final currentState = state;
    if (currentState is MainScreenLoadState) {
      yield currentState.copyWith(currentScreen: index);
    }
  }

  Stream<MainScreenState> reloadHomeScreen(List<UserModel> users) async* {
    final currentState = state;
    if (currentState is MainScreenLoadState) {
      yield currentState.copyWith(activeUsers: users);
    }
  }

  Stream<MainScreenState> reloadUser(UserModel user) async* {
    final currentState = state;
    if (currentState is MainScreenLoadState) {
      yield currentState.copyWith(currentUser: user);
    }
  }

  Stream<MainScreenState> userOnline() async* {
    final currentState = state;
    if (currentState is MainScreenLoadState) {
    }
  }

  Stream<MainScreenState> userOffline() async* {
    final currentState = state;
    if (currentState is MainScreenLoadState) {
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

}