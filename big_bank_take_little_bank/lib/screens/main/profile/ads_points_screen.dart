import 'dart:math';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:big_bank_take_little_bank/blocs/ads_rewards/ads_rewards.dart';
import 'package:big_bank_take_little_bank/models/rewards_model.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:big_bank_take_little_bank/utils/ad_manager.dart';
import 'package:big_bank_take_little_bank/widgets/animated_button.dart';
import 'package:big_bank_take_little_bank/widgets/app_button.dart';
import 'package:big_bank_take_little_bank/widgets/app_text.dart';
import 'package:big_bank_take_little_bank/widgets/stripe_widget.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toast/toast.dart';

class AdsPointsScreen extends StatefulWidget {
  final BuildContext homeContext;

  AdsPointsScreen({this.homeContext});
  @override
  State<AdsPointsScreen> createState() {
    return _AdsPointsScreenState(homeContext);
  }
}

class _AdsPointsScreenState extends State<AdsPointsScreen> {

  final BuildContext homeContext;
  _AdsPointsScreenState(this.homeContext);

  bool _isRewardedAdReady = false;
  num count = 0;
  AdmobReward rewardAd;

  @override
  void initState() {
    _isRewardedAdReady = false;
    // RewardedVideoAd.instance.listener = _onRewardedAdEvent;
    // _loadRewardedAd();
    rewardAd = AdmobReward(
      adUnitId: AdManager.appId,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        // if (event == AdmobAdEvent.closed) rewardAd.load();
        handleEvent(event, args, 'Reward');
      },
    );

    rewardAd.load();

    super.initState();
  }

  @override
  void dispose() {
    // RewardedVideoAd.instance.listener = null;
    rewardAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdsRewardsBloc, AdsRewardsState>(
      cubit: BlocProvider.of<AdsRewardsBloc>(homeContext),
      listener: (context, state) {
        if (state is AdsRewardsLoadState ) {
          if (count != state.rewardsList.length) {
            setState(() {
              count = state.rewardsList.length;
            });
          }
        }
      },
      child: BlocBuilder<AdsRewardsBloc, AdsRewardsState>(
        cubit: BlocProvider.of<AdsRewardsBloc>(homeContext),
        builder: (BuildContext context, AdsRewardsState state) {
          return Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg_home.png'),
                  fit: BoxFit.fill,
                )
            ),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              body: _body(state),
            ),
          );
        },
      ),
    );
  }

  Widget _body(AdsRewardsState state) {
    double progress = 0;
    if (state is AdsRewardsLoadState) {
      progress = MediaQuery.of(context).size.width * 0.08 * state.rewardsList.length.toDouble();
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        SafeArea(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 8,
                height: MediaQuery.of(context).size.width * 0.25,
                width: MediaQuery.of(context).size.width * 0.7,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Image.asset(
                        'assets/images/rewards_header.png',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Positioned(
                      left: 16,
                      top: 0,
                      child: Image.asset(
                        'assets/images/ic_1000.png',
                        width: MediaQuery.of(context).size.width * 0.2,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.width * 0.25 + 24,
                left: 16,
                right: 16,
                bottom: 16,
                child: Container(
                  padding: EdgeInsets.only(top: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/images/level_1_user_profile.png'),
                      Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 32,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xff0b3935),
                                  Color(0xff185458),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black87,
                                  spreadRadius: -3,
                                  blurRadius: 1,
                                  offset: Offset(3, 6),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            bottom: 0,
                            child: Container(
                              width: progress,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xff00ff9c),
                                    Color(0xff00d64c),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            bottom: 0,
                            child: Container(
                              width: progress,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: StripsWidget(
                                color1: Color(0x6300d64c),
                                color2: Color(0x63ffffff),
                                gap: 12,
                                noOfStrips: 100,
                              ),
                            ),
                          ),
                        ],
                      ),
                      AnimatedButton(
                        onTap: () async {
                          // if (_isRewardedAdReady) {
                          //   RewardedVideoAd.instance.show();
                          // }
                          if (await rewardAd.isLoaded) {
                            rewardAd.show();
                          } else {
                            Toast.show( 'Reward ad is still loading...', context);
                          }
                        },
                        content: Container(
                          width: 120,
                          child:  AppButton(
                            colorStyle: 'green',
                            titleWidget: AppGradientLabel(
                              title: 'WATCH AD',
                              shadow: true,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      AppButtonLabel(
                        title: '$count/10',
                        fontSize: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 44,
          left: 8,
          width: 44,
          height: 44,
          child: AnimatedButton(
            onTap: () {
              Navigator.pop(context);
            },
            content: Container(
              child:  Image.asset('assets/images/ic_back.png', ),
            ),
          ),
        ),
      ],
    );
  }

  MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['flutterio', 'beautiful apps'],
      contentUrl: 'https://flutter.io',
      testDevices: <String>['A6CB091DD6E765C87ED74D092E4568FE']);

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        showSnackBar('New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
        showSnackBar('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        showSnackBar('Admob $adType Ad closed!');
        rewardAd.load();
        break;
      case AdmobAdEvent.failedToLoad:
        showSnackBar('Admob $adType failed to load. :(');
        Future.delayed(Duration(minutes: 1), () {
          final re = rewardAd;
          re?.load();
        });
        break;
      case AdmobAdEvent.rewarded:
        int rewardsPoint = 0;
        if (count < 5) {
          rewardsPoint = 100 + Random().nextInt(400);
        } else if (count < 10) {
          rewardsPoint = 500 + Random().nextInt(500);
        } else {
          rewardsPoint = 1000;
        }
        RewardsModel rewardsModel = RewardsModel();
        rewardsModel.id = Global.instance.userId;
        rewardsModel.rewardPoint = rewardsPoint;
        rewardsModel.type = 'ads';
        rewardsModel.consecutive = count;
        BlocProvider.of<AdsRewardsBloc>(homeContext)..add(UpdateAdsRewards(rewardsModel: rewardsModel));
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return WillPopScope(
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Reward callback fired. Thanks Andrew!'),
                    Text('Type: ${args['type']}'),
                    Text('Amount: $rewardsPoint'),
                  ],
                ),
              ),
              onWillPop: () async {
                // scaffoldState.currentState.hideCurrentSnackBar();
                return true;
              },
            );
          },
        );
        break;
      default:
    }
  }

  void showSnackBar(String content) {
    // scaffoldState.currentState.showSnackBar(
    //   SnackBar(
    //     content: Text(content),
    //     duration: Duration(milliseconds: 1500),
    //   ),
    // );
  }


}
