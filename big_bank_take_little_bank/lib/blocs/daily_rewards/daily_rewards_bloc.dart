import 'dart:async';
import 'dart:math';

import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/blocs/daily_rewards/daily_rewards.dart';
import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/models/rewards_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:big_bank_take_little_bank/utils/ad_manager.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DailyRewardsBloc extends Bloc<DailyRewardsEvent, DailyRewardsState> {

  DailyRewardsBloc(DailyRewardsState initialState) : super(initialState);
  StreamSubscription _rewardsSubscription;
  static RewardsModel currentRewards;
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo();

  DailyRewardsState get initialState {
    return DailyRewardsInitState();
  }

  FirestoreService service = FirestoreService();

  @override
  Stream<DailyRewardsState> mapEventToState(DailyRewardsEvent event) async* {
    print(event);
    if (event is CheckDailyRewards) {
      RewardedVideoAd.instance.listener =
          (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
        print("RewardedVideoAd event $event");
        if (event == RewardedVideoAdEvent.rewarded) {
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
        } else if (event == RewardedVideoAdEvent.loaded) {
          RewardedVideoAd.instance.show();
        } else if (event == RewardedVideoAdEvent.failedToLoad) {
          Future.delayed(Duration(minutes: 1), () async {
            await load();
          });
        } else if (event == RewardedVideoAdEvent.closed) {

        }
      };

      yield* checkDailyRewards();
    } else if (event is AvailableDailyRewards) {
      yield DailyRewardsAcceptState(rewardsModel: event.rewardsModel);
    } else if (event is UpdateDailyRewards) {
      yield* updateDailyRewards(event.rewardsModel);
    }
  }

  Future<bool> load() async {
    return await RewardedVideoAd.instance.load(
        adUnitId: RewardedVideoAd.testAdUnitId,
        targetingInfo: targetingInfo);
  }

  Stream<DailyRewardsState> checkDailyRewards() async* {
    String userId = FirebaseAuth.instance.currentUser.uid;
    await _rewardsSubscription?.cancel();
    _rewardsSubscription = service.streamLastRewards(userId).listen((event) async {
      if (event.docs.length > 0) {
        RewardsModel lastRewards = RewardsModel.fromJson(event.docs.first.data());
        num consecutive = lastRewards.consecutive ?? 0;
        DateTime rewardsAt = lastRewards.rewardsAt;
        DateTime now = DateTime.now();
        print('rewards date => $rewardsAt');
        print('now => $now');
        if (rewardsAt.year == now.year && rewardsAt.month == now.month && rewardsAt.day == now.day) {

        } else {
          await load();
          currentRewards = lastRewards;
          add(ShouldShowAds(isAvailable: true));
          _rewardsSubscription.cancel();
        }
      } else {
        await load();
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
    return super.close();
  }

}