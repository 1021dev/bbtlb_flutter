import 'dart:async';

import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/models/gallery_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
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

  @override
  Future<void> close() {
    _gallerySubscription?.cancel();
    return super.close();
  }

}