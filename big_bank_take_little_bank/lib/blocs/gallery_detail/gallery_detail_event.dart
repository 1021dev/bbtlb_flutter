

import 'package:big_bank_take_little_bank/models/comment_model.dart';
import 'package:big_bank_take_little_bank/models/gallery_model.dart';
import 'package:big_bank_take_little_bank/models/liket_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class GalleryDetailEvent extends Equatable {
  const GalleryDetailEvent();

  @override
  List<Object> get props => [];
}

@immutable
class CheckGalleryDetail extends GalleryDetailEvent {
  final UserModel userModel;
  final GalleryModel galleryModel;
  CheckGalleryDetail({this.userModel, this.galleryModel});
}

class GalleryDetailLoadedEvent extends GalleryDetailEvent {
  final GalleryModel galleryModel;
  final List<CommentModel> commentList;
  final List<LikeModel> likeList;
  GalleryDetailLoadedEvent({this.galleryModel, this.commentList, this.likeList});
}

@immutable
class UpdateGalleryEvent extends GalleryDetailEvent {
  final GalleryModel galleryModel;

  UpdateGalleryEvent({this.galleryModel,});
}

@immutable
class DeleteGalleryEvent extends GalleryDetailEvent {
  final GalleryModel galleryModel;

  DeleteGalleryEvent({this.galleryModel,});
}

@immutable
class AddCommentEvent extends GalleryDetailEvent {
  final String uid;
  final String galleryId;
  final CommentModel commentModel;

  AddCommentEvent({this.uid, this.galleryId, this.commentModel,});
}

@immutable
class LikeEvent extends GalleryDetailEvent {
  final LikeModel likeModel;
  final String uid;
  final String galleryId;

  LikeEvent({this.likeModel, this.uid, this.galleryId});
}
