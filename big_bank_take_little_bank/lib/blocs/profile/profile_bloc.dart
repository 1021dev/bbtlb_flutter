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
import 'package:flutter_contact/contacts.dart';

class ProfileScreenBloc extends Bloc<ProfileScreenEvent, ProfileScreenState> {

  final MainScreenBloc mainScreenBloc;
  ProfileScreenBloc(ProfileScreenState initialState, {@required this.mainScreenBloc}) : super(initialState);
  StreamSubscription _userSubscription;
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
    }
  }

  Stream<ProfileScreenState> init() async* {
    User user = auth.currentUser;

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
    UserCredential result = await auth.signInWithEmailAndPassword(email: state.currentUser.email, password: oldPassword);
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

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}

extension DateComponentsFormat on DateComponents {
  String format() {
    return [year, month, day].where((d) => d != null).join('-');
  }
}