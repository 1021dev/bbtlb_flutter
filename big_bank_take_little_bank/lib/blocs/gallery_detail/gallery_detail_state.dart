import 'package:big_bank_take_little_bank/models/comment_model.dart';
import 'package:big_bank_take_little_bank/models/gallery_model.dart';
import 'package:big_bank_take_little_bank/models/liket_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class GalleryDetailState extends Equatable {

  GalleryDetailState();

  @override
  List<Object> get props => [];
}

class GalleryDetailInitState extends GalleryDetailState {
  final UserModel userModel;
  GalleryDetailInitState({this.userModel});
}

class GalleryDetailLoadState extends GalleryDetailState{
  final GalleryModel galleryModel;
  final UserModel userModel;
  final List<CommentModel> commentList;
  final List<LikeModel> likeList;

  GalleryDetailLoadState({
    this.galleryModel,
    this.userModel,
    this.commentList = const [],
    this.likeList = const [],
  });

  @override
  List<Object> get props => [
    galleryModel,
    userModel,
    commentList,
    likeList,
  ];
  GalleryDetailLoadState copyWith({
    GalleryModel galleryModel,
    UserModel userModel,
    List<CommentModel> commentList,
    List<LikeModel> likeList,
  }) {
    return GalleryDetailLoadState(
      galleryModel: galleryModel ?? this.galleryModel,
      userModel: userModel ?? this.userModel,
      commentList: commentList ?? this.commentList,
      likeList: likeList ?? this.likeList,
    );
  }
}

class GalleryDetailSuccess extends GalleryDetailState {}

class GalleryDetailFailure extends GalleryDetailState {
  final String error;

  GalleryDetailFailure({@required this.error}) : super();

  @override
  String toString() => 'GalleryDetailFailure { error: $error }';
}

