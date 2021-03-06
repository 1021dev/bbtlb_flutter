

import 'package:big_bank_take_little_bank/models/rewards_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class DailyRewardsEvent extends Equatable {
  const DailyRewardsEvent();

  @override
  List<Object> get props => [];
}

@immutable
class CheckDailyRewards extends DailyRewardsEvent {}

class AvailableDailyRewards extends DailyRewardsEvent {
  final RewardsModel rewardsModel;
  AvailableDailyRewards({this.rewardsModel});
}

class ShouldShowAds extends DailyRewardsEvent {
  final bool isAvailable;
  ShouldShowAds({this.isAvailable = false});
}

@immutable
class UpdateDailyRewards extends DailyRewardsEvent {
  final RewardsModel rewardsModel;

  UpdateDailyRewards({this.rewardsModel,});
}
