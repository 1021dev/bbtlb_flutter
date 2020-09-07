import 'dart:async';

import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/models/block_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {

  MainScreenBloc(MainScreenState initialState) : super(initialState);

  StreamSubscription _userSubscription;
  StreamSubscription _usersSubscription;
  StreamSubscription _blockUsersSubscription;

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
    } else if (event is UserOnlineEvent) {
      yield* userOnline();
    } else if (event is UserOfflineEvent) {
      yield* userOffline();
    } else if (event is SearchUserEvent) {
      yield* searchUsers(event.query);
    } else if (event is BlockListLoadedEvent) {
      yield* blockListLoaded(event.blockList);
    }
  }

  Stream<MainScreenState> init() async* {
    User user = FirebaseAuth.instance.currentUser;
    await _userSubscription?.cancel();
    _userSubscription = service.streamUser(user.uid).listen((event) {
      if (event != null) {
        Global.instance.userId = user.uid;
        Global.instance.userModel = event;
        add(MainScreenUserLoadedEvent(user: event));
      }
    });
    await _usersSubscription?.cancel();
    _usersSubscription = service.streamUsers().listen((event) {
      if (event != null) {
        add(MainScreenUsersLoadEvent(users: event));
      }
    });
    await _blockUsersSubscription?.cancel();
    _blockUsersSubscription = service.streamBlockList(Global.instance.userId).listen((event) {
      if (event.size > 0) {
        List<BlockModel> blockList = [];
        event.docs.forEach((element) {
          blockList.add(BlockModel.fromJson(element.data()));
        });
        add(BlockListLoadedEvent(blockList: blockList));
      } else {
        add(BlockListLoadedEvent(blockList: []));
      }
    });
    add(UserOnlineEvent());
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
      List<UserModel> userModels = [];
      userModels = users.where((element) {
        bool isBlock = false;
        currentState.blockList.forEach((block) {
          if (block.sender == element.id || block.receiver == element.id) {
            isBlock = true;
          }
        });
        return !isBlock;
      }).toList();
      yield currentState.copyWith(activeUsers: userModels);
    }
  }

  Stream<MainScreenState> blockListLoaded(List<BlockModel> blockList) async* {
    final currentState = state;
    if (currentState is MainScreenLoadState) {
      List<UserModel> userModels = [];
      userModels = currentState.activeUsers.where((element) {
        bool isBlock = false;
        blockList.forEach((block) {
          if (block.sender == element.id || block.receiver == element.id) {
            isBlock = true;
          }
        });
        return !isBlock;
      }).toList();
      yield currentState.copyWith(activeUsers: userModels, blockList: blockList);
    }
  }

  Stream<MainScreenState> reloadUser(UserModel user) async* {
    final currentState = state;
    if (currentState is MainScreenLoadState) {
      yield currentState.copyWith(currentUser: user);
    }
  }

  Stream<MainScreenState> userOnline() async* {
      await service.updateUser(Global.instance.userId, {'isLoggedIn': true});
  }

  Stream<MainScreenState> userOffline() async* {
      await service.updateUser(Global.instance.userId, {'isLoggedIn': false});
  }

  Stream<MainScreenState> searchUsers(String query) async* {
    final currentState = state;
    List<UserModel> searchUsers = [];
    if (currentState is MainScreenLoadState) {
      searchUsers = currentState.activeUsers.where((element) => element.name.toLowerCase().contains(query.toLowerCase())).toList();
      yield currentState.copyWith(filterUsers: searchUsers);
    }
  }
  @override
  Future<void> close() {
    _userSubscription?.cancel();
    _usersSubscription?.cancel();
    _blockUsersSubscription?.cancel();
    return super.close();
  }

}