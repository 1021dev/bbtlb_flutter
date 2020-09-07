import 'dart:async';
import 'dart:io';

import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/models/block_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/my_app.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contact/contacts.dart';

class ProfileScreenBloc extends Bloc<ProfileScreenEvent, ProfileScreenState> {

  final MainScreenBloc mainScreenBloc;
  ProfileScreenBloc(ProfileScreenState initialState, {@required this.mainScreenBloc}) : super(initialState);
  StreamSubscription _userSubscription;
  StreamSubscription _blockListSubscription;
  FirestoreService service = FirestoreService();
  ContactService _contactService = UnifiedContacts;

  ProfileScreenState get initialState {
    return ProfileScreenState(isLoading: true);
  }

  @override
  Stream<ProfileScreenState> mapEventToState(ProfileScreenEvent event,) async* {
    if (event is ProfileScreenInitEvent) {
      yield* init();
    } else if (event is UpdateProfileScreenEvent) {
      yield* updateProfile(event.userModel);
    } else if (event is ProfileScreenUserLoadedEvent) {
      yield state.copyWith(currentUser: event.user, isLoading: false);
    } else if (event is UploadProfileImageEvent) {
      yield* uploadProfileImage(event.image);
    } else if (event is ProfileScreenLogoutEvent) {
      yield* logout();
    } else if (event is GetContactsEvent) {
      yield* getContacts();
    } else if (event is UpdatePasswordEvent) {
      yield* updatePassword(event.oldPassword, event.newPassword);
    } else if (event is GetBlockListEvent) {
      yield* getBlockList();
    } else if (event is UpdateNotificationSetting) {
      yield* updateNotificationSetting(event.isNotification);
    } else if (event is LoadedBlockListEvent) {
      yield* loadedBlockList(event.blockList);
    } else if (event is UnBlockUserFromProfileEvent) {
      yield* unBlock(event.blockModel);
    }
  }

  Stream<ProfileScreenState> init() async* {
    User user = FirebaseAuth.instance.currentUser;

    await _userSubscription?.cancel();
    _userSubscription = service.streamUser(user.uid).listen((event) {
      if (event != null) {
        Global.instance.userId = user.uid;
        Global.instance.userModel = event;
        print(event.toJson());
        add(ProfileScreenUserLoadedEvent(user: event));
      }
    });
  }

  Stream<ProfileScreenState> uploadProfileImage(File file) async* {
    yield state.copyWith(isLoading: true);
    StorageReference ref = firebaseStorage.ref().child('users').child(state.currentUser.id);
    StorageUploadTask task = ref.putFile(file);
    task.events.listen((event) async* {
      double progress = event.snapshot.bytesTransferred.toDouble();
      print(progress);
    }).onError((error) async* {
      print(error.toString());
      yield state.copyWith(isLoading: false);
    });
    StorageTaskSnapshot snap = await task.onComplete;
    dynamic url = await snap.ref.getDownloadURL();
    await service.updateCurrentUser({
      'image': url.toString(),
    });
    yield ProfileScreenSuccess();

  }

  Stream<ProfileScreenState> updateProfile(UserModel userModel) async* {
    yield state.copyWith(isLoading: true);

    await service.updateCurrentUser(userModel.toJson());

    yield ProfileScreenSuccess();
  }

  Stream<ProfileScreenState> logout() async* {
    await service.updateUser(Global.instance.userId, {'isLoggedIn': false});
    yield state.copyWith(isLoading: true);

    await FirebaseAuth.instance.signOut();

    yield ProfileScreenLogout();
  }

  Stream<ProfileScreenState> getContacts() async* {
    yield state.copyWith(isLoading: true);

    final contacts = _contactService.listContacts(
        withUnifyInfo: true,
        withThumbnails: true,
        withHiResPhoto: true,
        sortBy: ContactSortOrder.firstName());
    final tmp = <Contact>[];
    while (await contacts.moveNext()) {
      tmp.add(await contacts.current);
    }

    yield state.copyWith(isLoading: false, contacts: tmp);
  }

  Stream<ProfileScreenState> updatePassword(String oldPassword, String newPassword) async* {
    yield state.copyWith(isLoading: true);
    UserCredential result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: state.currentUser.email, password: oldPassword);
    if (result.user != null) {
      User user = result.user;
      try {
        await user.updatePassword(newPassword);
        yield UpdatePasswordSuccess();
      } catch (error) {
        print("Password can't be changed" + error.toString());
        yield ProfileScreenFailure(error: 'This might happen, when the wrong password is in, the user isn\'t found, or if the user hasn\'t logged in recently');
      }
    } else {
      yield ProfileScreenFailure(error: 'This might happen, when the wrong password is in, the user isn\'t found, or if the user hasn\'t logged in recently');
    }
  }

  Stream<ProfileScreenState> getBlockList() async* {
    await _blockListSubscription?.cancel();
    _blockListSubscription = service.streamBlockList(Global.instance.userId).listen((event) {
      if (event.size > 0) {
        List<BlockModel> blockList = [];
        event.docs.forEach((element) {
          BlockModel blockModel = BlockModel.fromJson(element.data());
          if (blockModel.sender == Global.instance.userId) {
            blockList.add(blockModel);
          }
        });
        add(LoadedBlockListEvent(blockList: blockList));
      } else {
        add(LoadedBlockListEvent(blockList: []));
      }
    });
  }

  Stream<ProfileScreenState> loadedBlockList(List<BlockModel> models) async* {
    yield state.copyWith(blockList: models);
  }

  Stream<ProfileScreenState> updateNotificationSetting(bool isNotification) async* {
    yield state.copyWith(isLoading: true);
    await service.updateUser(Global.instance.userId, {'notification': isNotification});
  }

  Stream<ProfileScreenState> unBlock(BlockModel blockModel) async* {
    await service.deleteBlock(Global.instance.userId, blockModel);
    DocumentSnapshot blockDoc = await service.getBlock(blockModel.id);
    BlockModel userBlock = BlockModel.fromJson(blockDoc.data());

    if (userBlock != null) {
      await service.deleteBlock(blockModel.id, userBlock);
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    _blockListSubscription?.cancel();
    return super.close();
  }
}

extension DateComponentsFormat on DateComponents {
  String format() {
    return [year, month, day].where((d) => d != null).join('-');
  }
}