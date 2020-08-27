import 'package:big_bank_take_little_bank/models/rewards_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AdsRewardsState extends Equatable {

  AdsRewardsState();

  @override
  List<Object> get props => [];
}

class AdsRewardsInitState extends AdsRewardsState {}

class AdsRewardsLoadState extends AdsRewardsState{
  final List<RewardsModel> rewardsList;

  AdsRewardsLoadState({
    this.rewardsList,
  });

  @override
  List<Object> get props => [
    rewardsList,
  ];
  AdsRewardsLoadState copyWith({
    List<RewardsModel> rewardsList,
  }) {
    return AdsRewardsLoadState(
      rewardsList: rewardsList ?? this.rewardsList,
    );
  }
}

class AdsRewardsSuccess extends AdsRewardsState {}

class AdsRewardsFailure extends AdsRewardsState {
  final String error;

  AdsRewardsFailure({@required this.error}) : super();

  @override
  String toString() => 'AdsRewardsFailure { error: $error }';
}

