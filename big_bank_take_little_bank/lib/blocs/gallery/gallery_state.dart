import 'package:big_bank_take_little_bank/models/gallery_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class GalleryState extends Equatable {

  GalleryState();

  @override
  List<Object> get props => [];
}

class GalleryInitState extends GalleryState {
  final UserModel userModel;
  GalleryInitState({this.userModel});
}

class GalleryLoadState extends GalleryState{
  final List<GalleryModel> galleryList;
  final UserModel userModel;
  final double uploadProgress;
  final bool isUploading;
  // final List<LikeModel> userLikeList;

  GalleryLoadState({
    this.galleryList = const [],
    this.userModel,
    this.uploadProgress = 0.0,
    this.isUploading = false,
    // this.userLikeList = const [],
  });

  @override
  List<Object> get props => [
    galleryList,
    userModel,
    uploadProgress,
    isUploading,
    // userLikeList,
  ];
  GalleryLoadState copyWith({
    List<GalleryModel> galleryList,
    UserModel userModel,
    double uploadProgress,
    bool isUploading,
    // List<LikeModel> userLikeList,
  }) {
    return GalleryLoadState(
      galleryList: galleryList ?? this.galleryList,
      userModel: userModel ?? this.userModel,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      isUploading: isUploading ?? this.isUploading,
      // userLikeList: userLikeList ?? this.userLikeList,
    );
  }
}

class GallerySuccess extends GalleryState {}

class GalleryFailure extends GalleryState {
  final String error;

  GalleryFailure({@required this.error}) : super();

  @override
  String toString() => 'GalleryFailure { error: $error }';
}

