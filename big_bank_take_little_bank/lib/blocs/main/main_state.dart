import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainScreenState extends Equatable {
  final bool isLoading;

  MainScreenState({
    this.isLoading = false,
  });

  @override
  List<Object> get props => [
    isLoading,
  ];

  MainScreenState copyWith({
    bool isLoading,
  }) {
    return MainScreenState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class MainScreenSuccess extends MainScreenState {}

class MainScreenFailure extends MainScreenState {
  final String error;

  MainScreenFailure({@required this.error}) : super();

  @override
  String toString() => 'MainScreenFailure { error: $error }';
}

