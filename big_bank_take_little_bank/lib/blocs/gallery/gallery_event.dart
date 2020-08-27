

import 'package:big_bank_take_little_bank/models/gallery_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class GalleryEvent extends Equatable {
  const GalleryEvent();

  @override
  List<Object> get props => [];
}

@immutable
class CheckGallery extends GalleryEvent {
  final UserModel userModel;
  CheckGallery({this.userModel});
}

class GalleryLoadedEvent extends GalleryEvent {
  final List<GalleryModel> galleryList;
  GalleryLoadedEvent({this.galleryList});
}
