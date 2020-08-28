import 'dart:async';
import 'dart:io';

import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/models/gallery_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/my_app.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {

  GalleryBloc(GalleryState initialState) : super(initialState);
  StreamSubscription _gallerySubscription;
  GalleryState get initialState {
    return GalleryInitState();
  }

  FirestoreService service = FirestoreService();

  @override
  Stream<GalleryState> mapEventToState(GalleryEvent event) async* {
    if (event is CheckGallery) {
      yield* checkGallery(event.userModel);
    } else if (event is GalleryLoadedEvent) {
      yield GalleryLoadState(galleryList: event.galleryList);
    } else if (event is CreateGalleryEvent) {
      yield* createGallery(event.uid, event.galleryModel, event.file);
    }
  }

  Stream<GalleryState> checkGallery(UserModel userModel) async* {
    await _gallerySubscription?.cancel();
    _gallerySubscription = service.streamGalleryList(userModel.id).listen((event) {
      List<GalleryModel> galleryList = [];
      event.docs.forEach((element) {
        GalleryModel model = GalleryModel.fromJson(element.data());
        model.reference = element.reference;
        galleryList.add(model);
      });
      add(GalleryLoadedEvent(galleryList: galleryList));
    });
  }

  Stream<GalleryState> createGallery(String uid, GalleryModel galleryModel, File file) async* {
    final currentState = state;
    if (currentState is GalleryLoadState) {
      yield currentState.copyWith(isUploading: true);
    }
    StorageReference ref = firebaseStorage.ref().child('users').child(uid);
    StorageUploadTask task = ref.putFile(file);
    task.events.listen((event) async* {
      double progress = event.snapshot.bytesTransferred.toDouble();
      print(progress);

      if (currentState is GalleryLoadState) {
        yield currentState.copyWith(uploadProgress: progress);
      }
    }).onError((error) async* {
      print(error.toString());
      if (currentState is GalleryLoadState) {
        yield currentState.copyWith(isUploading: false);
      }
    });
    StorageTaskSnapshot snap = await task.onComplete;
    dynamic url = await snap.ref.getDownloadURL();
    galleryModel.image = url.toString();
    await service.createGallery(uid, galleryModel);
    if (currentState is GalleryLoadState) {
      yield currentState.copyWith(isUploading: false);
    }
    yield GallerySuccess();
  }

  @override
  Future<void> close() {
    _gallerySubscription?.cancel();
    return super.close();
  }

}