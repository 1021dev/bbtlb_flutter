import 'dart:async';

import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/models/comment_model.dart';
import 'package:big_bank_take_little_bank/models/gallery_model.dart';
import 'package:big_bank_take_little_bank/models/liket_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GalleryDetailBloc extends Bloc<GalleryDetailEvent, GalleryDetailState> {

  GalleryDetailBloc(GalleryDetailState initialState) : super(initialState);
  StreamSubscription _gallerySubscription;
  StreamSubscription _commentSubscription;
  StreamSubscription _likeSubscription;
  GalleryDetailState get initialState {
    return GalleryDetailInitState();
  }

  FirestoreService service = FirestoreService();

  @override
  Stream<GalleryDetailState> mapEventToState(GalleryDetailEvent event) async* {
    if (event is CheckGalleryDetail) {
      yield* checkGallery(event.userModel, event.galleryModel);
    } else if (event is GalleryDetailLoadedEvent) {
      yield* loadedGallery(event);
    } else if (event is UpdateGalleryEvent) {
      yield* updateGallery(event.galleryModel);
    } else if (event is AddCommentEvent) {
      yield* addComment(event.uid, event.galleryId, event.commentModel);
    } else if (event is LikeEvent) {
      yield* updateLike(event.uid, event.galleryId, event.likeModel);
    }
  }

  Stream<GalleryDetailState> checkGallery(UserModel userModel, GalleryModel galleryModel) async* {
    await _gallerySubscription?.cancel();
    _gallerySubscription = service.streamGalleryDetail(userModel.id, galleryModel.id).listen((event) {
      add(GalleryDetailLoadedEvent(galleryModel: event));
    });
    await _commentSubscription?.cancel();
    _commentSubscription = service.streamComments(userModel.id, galleryModel.id).listen((event) {
      List<CommentModel> commentList = [];
      event.docs.forEach((element) {
        CommentModel model = CommentModel.fromJson(element.data());
        model.reference = element.reference;
        commentList.add(model);
      });
      add(GalleryDetailLoadedEvent(commentList: commentList));
    });
    await _likeSubscription?.cancel();
    _likeSubscription = service.streamLikes(userModel.id, galleryModel.id).listen((event) {
      List<LikeModel> likeList = [];
      event.docs.forEach((element) {
        LikeModel model = LikeModel.fromJson(element.data());
        model.reference = element.reference;
        likeList.add(model);
      });
      add(GalleryDetailLoadedEvent(likeList: likeList));
    });
  }

  Stream<GalleryDetailState> loadedGallery(GalleryDetailLoadedEvent event) async* {

    final currentState = state;
    if (currentState is GalleryDetailLoadState) {
      if (event.galleryModel != null) {
        yield currentState.copyWith(galleryModel: event.galleryModel, );
      } else if (event.commentList != null) {
        yield currentState.copyWith(commentList: event.commentList, );
      } else if (event.likeList != null) {
        yield currentState.copyWith(likeList: event.likeList, );
      }
    } else {
      if (event.galleryModel != null) {
        yield GalleryDetailLoadState(galleryModel: event.galleryModel, );
      } else if (event.commentList != null) {
        yield GalleryDetailLoadState(commentList: event.commentList, );
      } else if (event.likeList != null) {
        yield GalleryDetailLoadState(likeList: event.likeList, );
      }
    }

  }

  Stream<GalleryDetailState> updateGallery(GalleryModel galleryModel) async* {
    await service.updateGallery(galleryModel);
  }

  Stream<GalleryDetailState> deleteGallery(GalleryModel galleryModel) async* {
    await service.deleteGallery(galleryModel);
  }

  Stream<GalleryDetailState> addComment(String uid, String galleryId, CommentModel commentModel) async* {
    await service.addComment(uid, galleryId, commentModel);
  }

  Stream<GalleryDetailState> updateLike(String uid, String galleryId, LikeModel likeModel) async* {
    await service.updateLike(uid, galleryId, likeModel);
  }

  @override
  Future<void> close() {
    _gallerySubscription?.cancel();
    _commentSubscription?.cancel();
    _likeSubscription?.cancel();
    return super.close();
  }

}