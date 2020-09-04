import 'dart:async';

import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/models/rewards_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/my_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
const String testDevice = 'YOUR_DEVICE_ID';

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
    } else if (event is AdsLoadSedEvent) {
      yield AdsRewardsLoadState(rewardsList: event.rewardsList);
    } else if (event is UpdateAdsRewards) {
      yield* updateAdsRewards(event.rewardsModel);
    }
  }

  Stream<AdsRewardsState> checkAdsRewards() async* {
    String userId = FirebaseAuth.instance.currentUser.uid;
    await _rewardsSubscription?.cancel();
    _rewardsSubscription = service.streamAdsRewards(userId).listen((event) {
      List<RewardsModel> rewardsList = [];
      event.docs.forEach((element) {
        rewardsList.add(RewardsModel.fromJson(element.data()));
      });
      add(AdsLoadSedEvent(rewardsList: rewardsList));
    });
  }

  Stream<AdsRewardsState> updateAdsRewards(RewardsModel rewardsModel) async* {
    final currentState = state;
    if (currentState is AdsRewardsLoadState) {
      rewardsModel.consecutive = currentState.rewardsList.length;
    }
    await service.addRewards(rewardsModel);
    UserModel userModel = await service.getUserWithId(rewardsModel.id);
    userModel.points = userModel.points + rewardsModel.rewardPoint;
    await service.updateUser(userModel.id, userModel.toJson());
  }

  @override
  Future<void> close() {
    _rewardsSubscription?.cancel();
    return super.close();
  }

}