import 'dart:async';

import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/models/friends_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/my_app.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {

  FriendsBloc(FriendsState initialState) : super(initialState);
  StreamSubscription _friendsSubscription;
  StreamSubscription _friendsListSubscription;
  FriendsState get initialState {
    return FriendsInitState();
  }

  FirestoreService service = FirestoreService();

  @override
  Stream<FriendsState> mapEventToState(FriendsEvent event) async* {
    if (event is LoadFriends) {
      yield* checkFriends(event.friendId);
    } else if (event is LoadFriendsList) {
      yield* loadFriendsList();
    } else if (event is RequestFriends) {
      yield* requestFriends(event.userModel);
    } else if (event is AcceptFriends) {
      yield* updateFriends(event.friendsModel, 'accept');
    } else if (event is DeclineFriends) {
      yield* updateFriends(event.friendsModel, 'decline');
    } else if (event is BlockFriends) {
      yield* updateFriends(event.friendsModel, 'block');
    } else if (event is LoadedFriendsEvent) {
      yield* loadedFriends(event.friendsModel);
    } else if (event is LoadedFriendsListEvent) {
      yield* loadedFriendsList(event.friendsList);
    }
  }

  Stream<FriendsState> checkFriends(String friendId) async* {
    String userId = auth.currentUser.uid;
    await _friendsSubscription?.cancel();
    _friendsSubscription = service.streamFriend(userId, friendId).listen((event) {
      print(event);
      if (event.data() != null) {
        add(LoadedFriendsEvent(friendsModel: FriendsModel.fromJson(event.data())));
      } else {
        add(LoadedFriendsEvent(friendsModel: FriendsModel()));
      }
    });
  }

  Stream<FriendsState> loadFriendsList() async* {
    String userId = auth.currentUser.uid;
    await _friendsListSubscription?.cancel();
    _friendsListSubscription = service.streamFriends(userId).listen((event) {
      add(LoadedFriendsListEvent(friendsList: event));
    });
  }

  Stream<FriendsState> requestFriends(UserModel userModel) async* {
    FriendsModel friendsModel = FriendsModel(id: userModel.id);
    friendsModel.name = userModel.name;
    friendsModel.image = userModel.image;
    friendsModel.sender = Global.instance.userId;
    friendsModel.status = 'pending';
    await service.addFriends(Global.instance.userId, friendsModel);

    FriendsModel userFriendsModel = FriendsModel(id: Global.instance.userId);
    userFriendsModel.name = Global.instance.userModel.name;
    userFriendsModel.image = Global.instance.userModel.image;
    userFriendsModel.sender = Global.instance.userId;
    userFriendsModel.status = 'pending';
    await service.addFriends(userModel.id, userFriendsModel);
  }

  Stream<FriendsState> updateFriends(FriendsModel friendsModel, String status) async* {
    friendsModel.status = status;

    await service.updateFriends(Global.instance.userId, friendsModel);

    DocumentSnapshot friendsDoc = await service.getFriend(friendsModel.id);
    FriendsModel userFriends = FriendsModel.fromJson(friendsDoc.data());

    if (userFriends != null) {
      userFriends.status = status;
      await service.updateFriends(friendsModel.id, userFriends);
    }
  }

  Stream<FriendsState> loadedFriends(FriendsModel friendsModel) async* {
    final currentState = state;
    if (currentState is FriendsLoadState) {
      yield currentState.copyWith(friendsModel: friendsModel);
    } else {
      yield FriendsLoadState(friendsModel: friendsModel);
    }
  }

  Stream<FriendsState> loadedFriendsList(List<FriendsModel> list) async* {
    final currentState = state;
    if (currentState is FriendsListLoadState) {
      yield currentState.copyWith(friendsList: list);
    } else {
      yield FriendsListLoadState(friendsList: list);
    }
  }

  @override
  Future<void> close() {
    _friendsSubscription?.cancel();
    _friendsListSubscription?.cancel();
    return super.close();
  }

}