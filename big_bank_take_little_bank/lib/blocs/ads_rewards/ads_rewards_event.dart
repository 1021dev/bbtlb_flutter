

import 'package:big_bank_take_little_bank/models/rewards_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AdsRewardsEvent extends Equatable {
  const AdsRewardsEvent();

  @override
  List<Object> get props => [];
}

@immutable
class CheckAdsRewards extends AdsRewardsEvent {}

class AdsLoadSedEvent extends AdsRewardsEvent {
  final List<RewardsModel> rewardsList;
  AdsLoadSedEvent({this.rewardsList});
}

@immutable
class UpdateAdsRewards extends AdsRewardsEvent {
  final RewardsModel rewardsModel;

  UpdateAdsRewards({this.rewardsModel,});
}
