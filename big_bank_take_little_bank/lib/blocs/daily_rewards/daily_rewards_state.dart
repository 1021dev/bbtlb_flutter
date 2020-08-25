import 'package:big_bank_take_little_bank/models/rewards_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class DailyRewardsState extends Equatable {

  DailyRewardsState();

  @override
  List<Object> get props => [];
}

class DailyRewardsInitState extends DailyRewardsState {}

class DailyRewardsAcceptState extends DailyRewardsState{
  final RewardsModel rewardsModel;

  DailyRewardsAcceptState({
    this.rewardsModel,
  });

  @override
  List<Object> get props => [
    rewardsModel,
  ];
}

class DailyRewardsSuccess extends DailyRewardsState {}

class DailyRewardsFailure extends DailyRewardsState {
  final String error;

  DailyRewardsFailure({@required this.error}) : super();

  @override
  String toString() => 'DailyRewardsFailure { error: $error }';
}

