import 'dart:async';
import 'dart:math';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/blocs/daily_rewards/daily_rewards.dart';
import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/models/rewards_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/my_app.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:big_bank_take_little_bank/utils/ad_manager.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DailyRewardsBloc extends Bloc<DailyRewardsEvent, DailyRewardsState> {

  DailyRewardsBloc(DailyRewardsState initialState) : super(initialState);
  StreamSubscription _rewardsSubscription;
  static RewardsModel currentRewards;
  AdmobReward rewardAd;

  DailyRewardsState get initialState {
    return DailyRewardsInitState();
  }

  FirestoreService service = FirestoreService();

  @override
  Stream<DailyRewardsState> mapEventToState(DailyRewardsEvent event) async* {
    print(event);
    if (event is CheckDailyRewards) {
      // RewardedVideoAd.instance.listener = _onRewardedAdEvent;
      rewardAd = AdmobReward(
        adUnitId: AdManager.appId,
        listener: (AdmobAdEvent event, Map<String, dynamic> args) {
          // if (event == AdmobAdEvent.closed) rewardAd.load();
          handleEvent(event, args, 'Reward');
        },
      );

      yield* checkDailyRewards();
    } else if (event is AvailableDailyRewards) {
      yield DailyRewardsAcceptState(rewardsModel: event.rewardsModel);
    } else if (event is UpdateDailyRewards) {
      yield* updateDailyRewards(event.rewardsModel);
    }
  }

  Stream<DailyRewardsState> checkDailyRewards() async* {
    String userId = FirebaseAuth.instance.currentUser.uid;
    await _rewardsSubscription?.cancel();
    _rewardsSubscription = service.streamLastRewards(userId).listen((event) {
      if (event.docs.length > 0) {
        RewardsModel lastRewards = RewardsModel.fromJson(event.docs.first.data());
        num consecutive = lastRewards.consecutive ?? 0;
        DateTime rewardsAt = lastRewards.rewardsAt;
        DateTime now = DateTime.now();
        print('rewards date => $rewardsAt');
        print('now => $now');
        if (rewardsAt.year == now.year && rewardsAt.month == now.month && rewardsAt.day == now.day) {

        } else {
          rewardAd.load();
          currentRewards = lastRewards;
          add(ShouldShowAds(isAvailable: true));
          _rewardsSubscription.cancel();
        }
      } else {
        rewardAd.load();
        add(ShouldShowAds(isAvailable: false));
      }
    });
  }

  Stream<DailyRewardsState> updateDailyRewards(RewardsModel rewardsModel) async* {
    if (state is DailyRewardsAcceptState) {
      await service.addRewards(rewardsModel);
      UserModel userModel = await service.getUserWithId(rewardsModel.id);
      userModel.points = userModel.points + rewardsModel.rewardPoint;
      await service.updateUser(userModel.id, userModel.toJson());
    }
  }

  @override
  Future<void> close() {
    _rewardsSubscription?.cancel();
    rewardAd.dispose();
    return super.close();
  }

  // void _loadRewardedAd() {
  //   RewardedVideoAd.instance.load(
  //     targetingInfo: targetingInfo,
  //     adUnitId: RewardedVideoAd.testAdUnitId,
  //   );
  // }

  void _onRewardedAdEvent(RewardedVideoAdEvent event,
      {String rewardType, int rewardAmount}) {
    switch (event) {
      case RewardedVideoAdEvent.loaded:
        RewardedVideoAd.instance.show();
        break;
      case RewardedVideoAdEvent.closed:
        // _loadRewardedAd();
        break;
      case RewardedVideoAdEvent.failedToLoad:
        print('Failed to load a rewarded ad');
        // Future.delayed(Duration(minutes: 1), () {
        //   _loadRewardedAd();
        // });
        break;
      case RewardedVideoAdEvent.rewarded:
        print('rewarded $rewardType,  $rewardAmount');
        if (currentRewards == null) {
          RewardsModel rewardsModel = new RewardsModel();
          rewardsModel.id = Global.instance.userId;
          rewardsModel.consecutive = 0;
          rewardsModel.rewardsAt = DateTime.now();
          rewardsModel.rewardPoint = 50;
          add(AvailableDailyRewards(rewardsModel: rewardsModel));
        } else {
          num consecutive = currentRewards.consecutive ?? 0;
          DateTime rewardsAt = currentRewards.rewardsAt;
          DateTime now = DateTime.now();
          if (rewardsAt.year == now.year && rewardsAt.month == now.month && rewardsAt.day == (now.day - 1)) {
            consecutive = consecutive + 1;
          } else {
            consecutive = 0;
          }
          num points = 50;
          if (consecutive == 1) {
            points = 50 + Random().nextInt(25);
          } else if (consecutive == 2) {
            points = 75 + Random().nextInt(25);
          } else if (consecutive == 3) {
            points = 100 + Random().nextInt(25);
          } else if (consecutive == 4) {
            points = 125 + Random().nextInt(25);
          } else if (consecutive == 5) {
            points = 150 + Random().nextInt(25);
          } else if (consecutive == 6) {
            points = 175 + Random().nextInt(25);
          } else if (consecutive == 7) {
            points = 200;
          }
          RewardsModel rewardsModel = new RewardsModel();
          rewardsModel.id = Global.instance.userId;
          rewardsModel.consecutive = consecutive;
          rewardsModel.rewardsAt = DateTime.now();
          rewardsModel.rewardPoint = points;
          add(AvailableDailyRewards(rewardsModel: rewardsModel));
        }

        break;
      default:
      // do nothing
    }
  }
  MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['flutterio', 'beautiful apps'],
      contentUrl: 'https://flutter.io',
      testDevices: <String>['A6CB091DD6E765C87ED74D092E4568FE']);

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        rewardAd.show();
        // showSnackBar('New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
        // showSnackBar('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        // showSnackBar('Admob $adType Ad closed!');
        // rewardAd.load();
        break;
      case AdmobAdEvent.failedToLoad:
        // showSnackBar('Admob $adType failed to load. :(');
        Future.delayed(Duration(minutes: 1), () {
          final re = rewardAd;
          re?.load();
        });
        break;
      case AdmobAdEvent.rewarded:
        if (currentRewards == null) {
          RewardsModel rewardsModel = new RewardsModel();
          rewardsModel.id = Global.instance.userId;
          rewardsModel.consecutive = 0;
          rewardsModel.rewardsAt = DateTime.now();
          rewardsModel.rewardPoint = 50;
          add(AvailableDailyRewards(rewardsModel: rewardsModel));
        } else {
          num consecutive = currentRewards.consecutive ?? 0;
          DateTime rewardsAt = currentRewards.rewardsAt;
          DateTime now = DateTime.now();
          if (rewardsAt.year == now.year && rewardsAt.month == now.month && rewardsAt.day == (now.day - 1)) {
            consecutive = consecutive + 1;
          } else {
            consecutive = 0;
          }
          num points = 50;
          if (consecutive == 1) {
            points = 50 + Random().nextInt(25);
          } else if (consecutive == 2) {
            points = 75 + Random().nextInt(25);
          } else if (consecutive == 3) {
            points = 100 + Random().nextInt(25);
          } else if (consecutive == 4) {
            points = 125 + Random().nextInt(25);
          } else if (consecutive == 5) {
            points = 150 + Random().nextInt(25);
          } else if (consecutive == 6) {
            points = 175 + Random().nextInt(25);
          } else if (consecutive == 7) {
            points = 200;
          }
          RewardsModel rewardsModel = new RewardsModel();
          rewardsModel.id = Global.instance.userId;
          rewardsModel.consecutive = consecutive;
          rewardsModel.rewardsAt = DateTime.now();
          rewardsModel.rewardPoint = points;
          add(AvailableDailyRewards(rewardsModel: rewardsModel));
        }
        break;
      default:
    }
  }

}