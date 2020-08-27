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

  GalleryLoadState({
    this.galleryList = const [],
    this.userModel,
  });

  @override
  List<Object> get props => [
    galleryList,
    userModel,
  ];
  GalleryLoadState copyWith({
    List<GalleryModel> galleryList,
    UserModel userModel,
  }) {
    return GalleryLoadState(
      galleryList: galleryList ?? this.galleryList,
      userModel: userModel ?? this.userModel,
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

