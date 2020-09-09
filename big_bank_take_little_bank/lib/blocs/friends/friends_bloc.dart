import 'dart:async';

import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/models/block_model.dart';
import 'package:big_bank_take_little_bank/models/friends_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {

  FriendsBloc(FriendsState initialState) : super(initialState);
  StreamSubscription _friendsSubscription;
  StreamSubscription _blockSubscription;
  StreamSubscription _friendsListSubscription;
  StreamSubscription _friendsRequestSubscription;
  FriendsState get initialState {
    return FriendsInitState();
  }

  FirestoreService service = FirestoreService();

  @override
  Stream<FriendsState> mapEventToState(FriendsEvent event) async* {
    if (event is LoadFriends) {
      yield* checkFriends(event.friendId);
    } else if (event is LoadOtherUserProfile) {
      yield* loadFriendProfile(event.friendId);
    } else if (event is LoadFriendsList) {
      yield* loadFriendsList();
    } else if (event is RequestFriends) {
      yield* requestFriends(event.userModel);
    } else if (event is AcceptFriends) {
      yield* updateFriends(event.friendsModel, 'accept');
    } else if (event is DeclineFriends) {
      yield* updateFriends(event.friendsModel, 'decline');
    } else if (event is CancelFriends) {
      yield* updateFriends(event.friendsModel, 'cancel');
    } else if (event is BlockFriends) {
      yield* updateBlock(event.blockModel, 'block');
    } else if (event is UnBlockFriends) {
      yield* updateBlock(event.blockModel, 'unblock');
    } else if (event is LoadedFriendsEvent) {
      yield* loadedFriends(event.friendsModel);
    } else if (event is LoadedBlockEvent) {
      yield* loadedBlock(event.blockModel);
    } else if (event is LoadedFriendsListEvent) {
      yield* loadedFriendsList(event.friendsList);
    } else if (event is LoadedRequestListEvent) {
      yield* loadedRequestList(event.requestList);
    }
  }

  Stream<FriendsState> checkFriends(String friendId) async* {
    await _friendsSubscription?.cancel();
    _friendsSubscription = service.streamFriend(Global.instance.userId, friendId).listen((event) {
      if (event.data() != null) {
        add(LoadedFriendsEvent(friendsModel: FriendsModel.fromJson(event.data())));
      } else {
        add(LoadedFriendsEvent(friendsModel: new FriendsModel()));
      }
    });
    await _blockSubscription?.cancel();
    _blockSubscription = service.streamBlock(Global.instance.userId, friendId).listen((event) {
      if (event.data() != null) {
        add(LoadedBlockEvent(blockModel: BlockModel.fromJson(event.data())));
      } else {
        add(LoadedBlockEvent(blockModel: new BlockModel()));
      }
    });
  }

  Stream<FriendsState> loadFriendsList() async* {
    await _friendsListSubscription?.cancel();
    _friendsListSubscription = service.streamFriends(Global.instance.userId).listen((event) {
      if (event.size > 0) {
        List<FriendsModel> friends = [];
        event.docs.forEach((element) {
          friends.add(FriendsModel.fromJson(element.data()));
        });
        add(LoadedFriendsListEvent(friendsList: friends));
      } else {
        add(LoadedFriendsListEvent(friendsList: []));
      }
    });
    await _friendsRequestSubscription?.cancel();
    _friendsRequestSubscription = service.streamFriendsRequests(Global.instance.userId).listen((event) {
      if (event.size > 0) {
        List<FriendsModel> friends = [];
        event.docs.forEach((element) {
          friends.add(FriendsModel.fromJson(element.data()));
        });
        add(LoadedRequestListEvent(requestList: friends));
      } else {
        add(LoadedRequestListEvent(requestList: []));
      }
    });
  }

  Stream<FriendsLoadState> requestFriends(UserModel userModel) async* {
    FriendsModel friendsModel = FriendsModel(id: userModel.id);
    friendsModel.name = userModel.name;
    friendsModel.image = userModel.image;
    friendsModel.sender = Global.instance.userId;
    friendsModel.receiver = userModel.id;
    friendsModel.status = 'pending';
    await service.addFriends(Global.instance.userId, friendsModel);

    FriendsModel userFriendsModel = FriendsModel(id: Global.instance.userId);
    userFriendsModel.name = Global.instance.userModel.name;
    userFriendsModel.image = Global.instance.userModel.image;
    userFriendsModel.sender = Global.instance.userId;
    userFriendsModel.receiver = userModel.id;
    userFriendsModel.status = 'pending';
    await service.addFriends(userModel.id, userFriendsModel);
    final currentState = state;
    if (currentState is FriendsLoadState) {
      yield currentState.copyWith(friendsModel: friendsModel);
    } else {
      yield FriendsLoadState(friendsModel: friendsModel);
    }
  }

  Stream<FriendsState> updateFriends(FriendsModel friendsModel, String status) async* {
    if (status == 'cancel') {
      await service.deleteFriends(Global.instance.userId, friendsModel);

      DocumentSnapshot friendsDoc = await service.getFriend(friendsModel.id);
      FriendsModel userFriends = FriendsModel.fromJson(friendsDoc.data());

      if (userFriends != null) {
        await service.deleteFriends(friendsModel.id, userFriends);
      }
    } else {
      friendsModel.status = status;

      await service.updateFriends(Global.instance.userId, friendsModel);

      DocumentSnapshot friendsDoc = await service.getFriend(friendsModel.id);
      FriendsModel userFriends = FriendsModel.fromJson(friendsDoc.data());

      if (userFriends != null) {
        userFriends.status = status;
        await service.updateFriends(friendsModel.id, userFriends);
      }
    }
  }

  Stream<FriendsState> updateBlock(BlockModel blockModel, String status) async* {
    if (status == 'unblock') {
      await service.deleteBlock(Global.instance.userId, blockModel);

      DocumentSnapshot blockDoc = await service.getBlock(blockModel.id);
      BlockModel userBlock = BlockModel.fromJson(blockDoc.data());

      if (userBlock != null) {
        await service.deleteBlock(blockModel.id, userBlock);
      }
    } else {
      await service.updateBlock(Global.instance.userId, blockModel);
      await service.userCollection
          .doc(Global.instance.userId)
          .collection('friends')
          .doc(blockModel.id)
          .delete();
      await service.userCollection
          .doc(blockModel.id)
          .collection('friends')
          .doc(Global.instance.userId)
          .delete();

      BlockModel userBlock = BlockModel(
        id: blockModel.sender,
        sender: blockModel.sender,
        receiver: blockModel.receiver,
        status: 'block',
      );
      await service.updateBlock(blockModel.id, userBlock);
    }
  }

  Stream<FriendsState> loadedFriends(FriendsModel friendsModel) async* {
    final currentState = state;
    UserModel userModel;
    if (currentState is FriendsInitState) {
      userModel = currentState.userModel;
    }
    if (currentState is FriendsLoadState) {
      yield currentState.copyWith(friendsModel: friendsModel);
    } else {
      if (userModel != null) {
        yield FriendsLoadState(friendsModel: friendsModel, userModel: userModel);
      } else {
        yield FriendsLoadState(friendsModel: friendsModel);
      }
    }
  }

  Stream<FriendsState> loadedBlock(BlockModel blockModel) async* {
    final currentState = state;
    UserModel userModel;
    if (currentState is FriendsInitState) {
      userModel = currentState.userModel;
    }
    if (currentState is FriendsLoadState) {
      yield currentState.copyWith(blockModel: blockModel);
    } else {
      if (userModel != null) {
        yield FriendsLoadState(blockModel: blockModel, userModel: userModel);
      } else {
        yield FriendsLoadState(blockModel: blockModel);
      }
    }
  }

  Stream<FriendsState> loadedFriendsList(List<FriendsModel> friends) async* {
    final currentState = state;
    if (currentState is FriendsListLoadState) {
      List<FriendsGroupModel> groupList = [];
      List<FriendsModel> requests = [];
      requests.addAll(currentState.requestList);
      requests.forEach((element) {
        groupList.add(FriendsGroupModel(group: '', friendsModel: element));
      });
      friends.forEach((element) {
        groupList.add(FriendsGroupModel(group: element.getGroup(), friendsModel: element));
      });
      groupList.sort((g1, g2) => g1.group.compareTo(g2.group));
      yield currentState.copyWith(friendsList: friends, friendsGroupList: groupList);
    } else {
      List<FriendsGroupModel> groupList = [];
      friends.forEach((element) {
        groupList.add(FriendsGroupModel(group: element.getGroup(), friendsModel: element));
      });
      yield FriendsListLoadState(friendsList: friends, friendsGroupList: groupList);
    }
  }

  Stream<FriendsState> loadedRequestList(List<FriendsModel> requests) async* {
    final currentState = state;
    if (currentState is FriendsListLoadState) {
      List<FriendsGroupModel> groupList = [];
      List<FriendsModel> friends = [];
      friends.addAll(currentState.friendsList);
      requests.forEach((element) {
        groupList.add(FriendsGroupModel(group: '', friendsModel: element));
      });
      friends.forEach((element) {
        groupList.add(FriendsGroupModel(group: element.getGroup(), friendsModel: element));
      });
      groupList.sort((g1, g2) => g1.group.compareTo(g2.group));
      yield currentState.copyWith(requestList: requests, friendsGroupList: groupList);
      print(groupList);
    } else {
      List<FriendsGroupModel> groupList = [];
      requests.forEach((element) {
        groupList.add(FriendsGroupModel(group: '', friendsModel: element));
      });
      print(groupList);
      yield FriendsListLoadState(requestList: requests, friendsGroupList: groupList);
    }
  }

  Stream<FriendsState> loadFriendProfile(String userId) async* {
    UserModel userModel = await service.getUserWithId(userId);
    final currentState = state;
    if (currentState is FriendsLoadState) {
      yield currentState.copyWith(userModel: userModel);
    } else {
      yield FriendsLoadState(userModel: userModel);
    }
    add(LoadFriends(friendId: userId));
  }

  @override
  Future<void> close() {
    _friendsSubscription?.cancel();
    _blockSubscription?.cancel();
    _friendsListSubscription?.cancel();
    _friendsRequestSubscription?.cancel();
    return super.close();
  }

}