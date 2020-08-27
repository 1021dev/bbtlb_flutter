import 'package:big_bank_take_little_bank/models/rewards_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AdsRewardsState extends Equatable {

  AdsRewardsState();

  @override
  List<Object> get props => [];
}

class AdsRewardsInitState extends AdsRewardsState {}

class AdsRewardsAcceptState extends AdsRewardsState{
  final RewardsModel rewardsModel;

  AdsRewardsAcceptState({
    this.rewardsModel,
  });

  @override
  List<Object> get props => [
    rewardsModel,
  ];
}

class AdsRewardsSuccess extends AdsRewardsState {}

class AdsRewardsFailure extends AdsRewardsState {
  final String error;

  AdsRewardsFailure({@required this.error}) : super();

  @override
  String toString() => 'AdsRewardsFailure { error: $error }';
}

