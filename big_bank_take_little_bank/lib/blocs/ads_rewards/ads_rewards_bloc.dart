import 'dart:async';
import 'dart:math';

import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/blocs/daily_rewards/daily_rewards.dart';
import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/models/rewards_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/my_app.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdsRewardsBloc extends Bloc<AdsRewardsEvent, AdsRewardsState> {

  AdsRewardsBloc(AdsRewardsState initialState) : super(initialState);
  StreamSubscription _rewardsSubscription;
  AdsRewardsState get initialState {
    return AdsRewardsInitState();
  }

  FirestoreService service = FirestoreService();

  @override
  Stream<AdsRewardsState> mapEventToState(AdsRewardsEvent event) async* {
    if (event is CheckAdsRewards) {
      yield* checkAdsRewards();
    } else if (event is AvailableAdsRewards) {
      yield AdsRewardsAcceptState(rewardsModel: event.rewardsModel);
    } else if (event is UpdateAdsRewards) {
      yield* updateAdsRewards(event.rewardsModel);
    }
  }

  Stream<AdsRewardsState> checkAdsRewards() async* {
    String userId = auth.currentUser.uid;
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
          rewardsModel.id = userId;
          rewardsModel.consecutive = consecutive;
          rewardsModel.rewardsAt = DateTime.now();
          rewardsModel.rewardPoint = points;
          add(AvailableAdsRewards(rewardsModel: rewardsModel));
          _rewardsSubscription.cancel();
        }
      } else {
        RewardsModel rewardsModel = new RewardsModel();
        rewardsModel.id = userId;
        rewardsModel.consecutive = 0;
        rewardsModel.rewardsAt = DateTime.now();
        rewardsModel.rewardPoint = 50;
        add(AvailableAdsRewards(rewardsModel: rewardsModel));
        _rewardsSubscription.cancel();
      }
    });
  }

  Stream<AdsRewardsState> updateAdsRewards(RewardsModel rewardsModel) async* {
    if (state is AdsRewardsAcceptState) {
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