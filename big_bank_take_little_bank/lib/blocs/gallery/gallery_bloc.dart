import 'dart:async';
import 'dart:io';

import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/models/gallery_model.dart';
import 'package:big_bank_take_little_bank/models/liket_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/my_app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      yield GalleryLoadState(galleryList: event.galleryList, userModel: event.userModel);
      // yield* loadUserLikes(event.userModel);
    } else if (event is CreateGalleryEvent) {
      yield* createGallery(event.uid, event.galleryModel, event.file);
    } else if (event is GalleryLikeEvent) {
      yield* updateLike(event.uid, event.galleryModel, event.likeModel);
    } else if (event is DeleteGalleryEvent) {
      yield* deleteGallery(event.uid, event.galleryModel);
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
      add(GalleryLoadedEvent(galleryList: galleryList, userModel: userModel));
    });
  }

  Stream<GalleryState> createGallery(String uid, GalleryModel galleryModel, File file) async* {
    final currentState = state;
    if (currentState is GalleryLoadState) {
      yield currentState.copyWith(isUploading: true);
    }
    StorageReference ref = firebaseStorage.ref().child('gallery').child(uid).child(galleryModel.id);
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

  // Stream<GalleryState> loadUserLikes(UserModel userModel) async* {
  //   final currentState = state;
  //   if (currentState is GalleryLoadState) {
  //     List<LikeModel> likeList = [];
  //     for (GalleryModel galleryModel in currentState.galleryList) {
  //       final userLikeDoc = await service.getUserLike(userModel.id, galleryModel.id);
  //       if (userLikeDoc.data() != null) {
  //         likeList.add(LikeModel.fromJson(userLikeDoc.data()));
  //       }
  //     }
  //     yield currentState.copyWith(userLikeList: likeList);
  //   }
  // }

  Stream<GalleryState> updateLike(String uid, GalleryModel galleryModel, LikeModel likeModel) async* {
    await service.updateLike(uid, galleryModel.id, likeModel);
    GalleryModel gm = galleryModel;
    gm.likeCount = galleryModel.likeCount + (likeModel.like ? 1: -1);
    await service.updateGallery(uid, gm);
  }

  Stream<GalleryState> deleteGallery(String uid, GalleryModel galleryModel) async* {
    await service.deleteGallery(uid, galleryModel);
  }

  @override
  Future<void> close() {
    _gallerySubscription?.cancel();
    return super.close();
  }

}