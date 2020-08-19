
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class MainScreenEvent extends Equatable {
  const MainScreenEvent();

  @override
  List<Object> get props => [];
}


@immutable
class MainScreenInitEvent extends MainScreenEvent {}
