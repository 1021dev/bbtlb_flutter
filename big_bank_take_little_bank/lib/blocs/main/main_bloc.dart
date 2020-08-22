import 'dart:async';

import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/my_app.dart';
import 'package:big_bank_take_little_bank/utils/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {

  MainScreenBloc(MainScreenState initialState) : super(initialState);
  StreamSubscription _userSubscription;
  MainScreenState get initialState {
    return MainScreenState(isLoading: false);
  }

  FirestoreService service = FirestoreService();

  @override
  Stream<MainScreenState> mapEventToState(MainScreenEvent event,) async* {
    if (event is MainScreenInitEvent) {
      yield* init();
    } else if (event is UpdateScreenEvent) {
      yield state.copyWith(currentScreen: event.screenIndex);
    } else if (event is MainScreenUserLoadedEvent) {
      yield state.copyWith(currentUser: event.user);
    }
  }

  Stream<MainScreenState> init() async* {
    yield state.copyWith(currentScreen: 4);
    SharedPrefService prefService = SharedPrefService.internal();
    User user = auth.currentUser;

    await _userSubscription?.cancel();
    _userSubscription = service.streamUser(user.uid).listen((event) {
      if (event != null) {
        add(MainScreenUserLoadedEvent(user: event));
      }
    });
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

}