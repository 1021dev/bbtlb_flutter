import 'dart:async';
import 'dart:io';

import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/my_app.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreenBloc extends Bloc<ProfileScreenEvent, ProfileScreenState> {

  final MainScreenBloc mainScreenBloc;
  ProfileScreenBloc(ProfileScreenState initialState, {@required this.mainScreenBloc}) : super(initialState);
  StreamSubscription _userSubscription;
  FirestoreService service = FirestoreService();

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
    }
  }

  Stream<ProfileScreenState> init() async* {
    FirebaseUser user = await auth.currentUser();

    await _userSubscription?.cancel();
    _userSubscription = service.streamUser(user.uid).listen((event) {
      if (event != null) {
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
    yield state.copyWith(isLoading: true);

    await auth.signOut();

    yield ProfileScreenLogout();
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }


}