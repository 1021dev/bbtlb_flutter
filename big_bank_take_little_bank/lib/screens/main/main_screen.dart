
import 'dart:math';

import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/models/challenge_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:big_bank_take_little_bank/screens/main/celebrity/celebrity_challenge_screen.dart';
import 'package:big_bank_take_little_bank/screens/main/challenge/game_in_screen.dart';
import 'package:big_bank_take_little_bank/screens/main/challenge/game_requested_screen.dart';
import 'package:big_bank_take_little_bank/screens/main/daily_rewards/daily_rewards_screen.dart';
import 'package:big_bank_take_little_bank/screens/main/forum/forum_screen.dart';
import 'package:big_bank_take_little_bank/screens/main/friends/friends_screen.dart';
import 'package:big_bank_take_little_bank/screens/main/friends/other_user_profile_screen.dart';
import 'package:big_bank_take_little_bank/screens/main/home/home_screen.dart';
import 'package:big_bank_take_little_bank/screens/main/message/chat_list_screen.dart';
import 'package:big_bank_take_little_bank/screens/main/newar_by/map_screen.dart';
import 'package:big_bank_take_little_bank/screens/main/settings/settings_screen.dart';
import 'package:big_bank_take_little_bank/screens/main/stats/stats_screen.dart';
import 'package:big_bank_take_little_bank/utils/ad_manager.dart';
import 'package:big_bank_take_little_bank/widgets/make_circle.dart';
import 'package:big_bank_take_little_bank/widgets/profile_avatar.dart';
import 'package:big_bank_take_little_bank/widgets/pulse_widget.dart';
import 'package:big_bank_take_little_bank/widgets/radial_menu.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';

import 'challenge/challenge_pending_screen.dart';


class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver{
  final GlobalKey<CircularMenuState> key = GlobalKey<CircularMenuState>();
  // ignore: close_sinks
  MainScreenBloc mainScreenBloc;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    mainScreenBloc = MainScreenBloc(MainScreenInitState());
    mainScreenBloc.add(UserLoginEvent());
    // WidgetsBinding.instance.addObserver(this);
    // _firebaseMessaging.requestNotificationPermissions();
    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //     if (Platform.isAndroid) {
    //       mainScreenBloc.add(ShowAndroidNotificationsEvent(notification: message));
    //     }
    //   },
    //   onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //   },
    // );
    //
    // _firebaseMessaging.onIosSettingsRegistered
    //     .listen((IosNotificationSettings settings) {
    //   print("Settings registered: $settings");
    // });
    // _firebaseMessaging.getToken().then((String token) {
    //   assert(token != null);
    //   print("Push Messaging token: $token");
    //   Global.instance.setToken(token);
    // });
    // _firebaseMessaging.subscribeToTopic("matchscore");
  }

  @override
  void dispose() {
    mainScreenBloc.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (mainScreenBloc != null) {
      if (state == AppLifecycleState.resumed) {
        mainScreenBloc.add(UserOnlineEvent());
        Global.instance.updatePushToken();
      } else {
        mainScreenBloc.add(UserOfflineEvent());
      }
    }
  }

  @override
  Widget build(BuildContext buildContext) {
    // ignore: close_sinks
    final DailyRewardsBloc dailyRewardsBloc = DailyRewardsBloc(DailyRewardsInitState());
    // ignore: close_sinks
    final AdsRewardsBloc adsRewardsBloc = AdsRewardsBloc(AdsRewardsInitState());
    // ignore: close_sinks
    final ChallengeBloc challengeBloc = ChallengeBloc(ChallengeState());
    // ignore: close_sinks
    final NotificationScreenBloc notificationScreenBloc = NotificationScreenBloc(NotificationScreenState());
    // ignore: close_sinks
    final ChatScreenBloc chatScreenBloc = ChatScreenBloc(ChatScreenState());
    // ignore: close_sinks
    final GameBloc gameBloc = GameBloc(GameState());
    return MultiBlocProvider(
      providers: [
        BlocProvider<DailyRewardsBloc>(
          create: (BuildContext context) {
            return dailyRewardsBloc
              ..add(CheckDailyRewards());
          },
        ),
        BlocProvider<MainScreenBloc>(
          create: (BuildContext context) {
            return mainScreenBloc
              ..add(MainScreenInitEvent());
          },
        ),
        BlocProvider<AdsRewardsBloc>(
          create: (BuildContext context) {
            return adsRewardsBloc
              ..add(CheckAdsRewards());
          },
        ),
        BlocProvider<ChallengeBloc>(
          create: (BuildContext context) {
            return challengeBloc
              ..add(ChallengeInitEvent());
          },
        ),
        BlocProvider<NotificationScreenBloc>(
          create: (BuildContext context) {
            return notificationScreenBloc
              ..add(NotificationInitEvent());
          },
        ),
        BlocProvider<ChatScreenBloc>(
          create: (BuildContext context) {
            return chatScreenBloc
              ..add(ChatInitEvent());
          },
        ),
        BlocProvider<GameBloc>(
          create: (BuildContext context) {
            return gameBloc;
          },
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<MainScreenBloc, MainScreenState>(
            listener: (BuildContext context, MainScreenState state) async {
              if (state is MainScreenLoadState) {
              } else if(state is MainScreenFailure) {
                showCupertinoDialog(
                    context: context, builder: (BuildContext context) {
                  return CupertinoAlertDialog(
                    title: Text('Oops'),
                    content: Text('state.error'),
                    actions: [
                      CupertinoDialogAction(
                        child: Text('Ok'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                });
              }
            },
          ),
          BlocListener<DailyRewardsBloc, DailyRewardsState>(
            listenWhen: (previousState, state) {
              if (previousState != state && state is DailyRewardsAcceptState) {
                return true;
              } else {
                return false;
              }
            },
            listener: (BuildContext context, DailyRewardsState state) async {
              if (state is DailyRewardsAcceptState) {
                showDialog(
                  context: context,
                  builder: (BuildContext con) {
                    return DailyRewardsDialog(homeContext: context,);
                  },
                );
              }
            },
          ),
          BlocListener<GameBloc, GameState>(
            listenWhen: (previousState, state) {
              if (previousState != state ) {
                return true;
              } else {
                return false;
              }
            },
            listener: (BuildContext gCtx, GameState gstate) async {
              if (gstate is GameInState) {
                if (gstate.challengeModel.type == 'schedule') {
                  return;
                }
                Navigator.push(
                  gCtx,
                  PageTransition(
                    child: GameInScreen(
                      userModel: gstate.userModel,
                      challengeModel: gstate.challengeModel,
                    ),
                    type: PageTransitionType.fade,
                    duration: Duration(milliseconds: 300),
                  ),
                );
              } else if (gstate is GameDeclinedState) {

              } else if (gstate is GameResultState) {
                // if (gstate.userModel.points == Global.instance.userModel.points) {
                //   Navigator.push(
                //     gCtx,
                //     PageTransition(
                //       child: GameTieTempScreen(),
                //       type: PageTransitionType.fade,
                //       duration: Duration(milliseconds: 300),
                //     ),
                //   );
                // } else if (gstate.userModel.points > Global.instance.userModel.points) {
                //   Navigator.push(
                //     gCtx,
                //     PageTransition(
                //       child: GameLossTempScreen(),
                //       type: PageTransitionType.fade,
                //       duration: Duration(milliseconds: 300),
                //     ),
                //   );
                // } else {
                //   Navigator.push(
                //     gCtx,
                //     PageTransition(
                //       child: GameWinTempScreen(
                //         points: gstate.userModel.points,
                //         challengeModel: gstate.challengeModel,
                //       ),
                //       type: PageTransitionType.fade,
                //       duration: Duration(milliseconds: 300),
                //     ),
                //   );
                // }

              } else if (gstate is GameCanceledState) {

              } else if (gstate is GameNotAnsweredState) {

              } else if (gstate is GameRequestedState) {
                showDialog(
                  context: context,
                  builder: (BuildContext cctx) {
                    return FutureBuilder(
                      future: FirestoreService().getUserWithId(gstate.challengeModel.sender),
                      builder: (fctx, snapshot) {
                        if (snapshot.data == null) {
                          return Container();
                        }
                        return GameRequestedScreen(
                          challengeModel: gstate.challengeModel,
                          userModel: snapshot.data,
                          onProfile: () {
                            Navigator.pop(cctx);
                            Navigator.push(
                              cctx,
                              PageTransition(
                                child: OtherUserProfileScreen(
                                  userModel: snapshot.data,
                                  screenBloc: BlocProvider.of<MainScreenBloc>(gCtx),
                                ),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 300),
                              ),
                            );
                          },
                          onAccept: () async {
                            Navigator.pop(cctx);
                            if (gstate.challengeModel != null) {
                              DateTime dateTime = gstate.challengeModel.challengeTime;
                              Duration duration = DateTime.now().difference(dateTime);
                              int seconds = (duration.inSeconds - 120);
                              if (seconds < 0) {
                                BlocProvider.of<ChallengeBloc>(gCtx)..add(ResponseChallengeRequestEvent(
                                  challengeModel: gstate.challengeModel, response: 'accept',
                                ));
                              }
                            }
                          },
                          onDecline: () {
                            Navigator.pop(cctx);
                            if (gstate.challengeModel != null) {
                              DateTime dateTime = gstate.challengeModel.challengeTime;
                              Duration duration = DateTime.now().difference(dateTime);
                              int seconds = (duration.inSeconds - 120);
                              if (seconds < 0) {
                                BlocProvider.of<ChallengeBloc>(gCtx).add(ResponseChallengeRequestEvent(
                                    challengeModel: gstate.challengeModel, response: 'decline'
                                ));
                              }
                            }
                          },
                        );
                      },
                    );
                  },
                );
              }
            },
          ),
          BlocListener<ChallengeBloc, ChallengeState>(
            cubit: challengeBloc,
            listener: (BuildContext cblCtx, ChallengeState cState) async {

            },
          ),
        ],
        child: MainScreenContent(),
      ),
    );
  }
}

class MainScreenContent extends StatefulWidget {
  MainScreenContent({Key key}) : super(key: key);

  @override
  _MainScreenContentState createState() => _MainScreenContentState();
}

class _MainScreenContentState extends State<MainScreenContent>
    with TickerProviderStateMixin {

  AnimationController _controller;
  AnimationController ringsController;
  Animation<double> ringTransition;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
    );
    ringsController = new AnimationController(vsync: this);
    ringTransition = Tween<double>(
      begin: 0.0,
      end: -2 * pi,
    ).animate(
      CurvedAnimation(
        parent: ringsController,
        curve: Curves.linear,
      ),
    );
    _initAdMob();
    _startAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    ringsController.dispose();
    super.dispose();
  }

  void _startAnimation() {
    // _controller.stop();
    // _controller.reset();
    _controller.repeat(
      period: Duration(seconds: 1),
    );
    ringsController.repeat(
      period: Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            width: MediaQuery.of(context).size.height,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff0e5073),
                  Color(0xff35996a),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          AnimatedBuilder(
            animation: ringsController,
            builder: (context, builder) {
              return Transform(
                transform: Matrix4.identity()..translate(
                  30.0 * cos(ringTransition.value),
                  30.0 * sin(ringTransition.value),
                ),
                child: Container(
                  // width: MediaQuery.of(context).size.height * 1.2,
                  // height: MediaQuery.of(context).size.height * 1.2,
                  decoration: MakeCircle(
                    animation: ringTransition,
                    strokeWidth: 36,
                    strokeCap: StrokeCap.square,
                  ),
                  // child: Image.asset('assets/images/rings.png', fit: BoxFit.cover,),
                ),
              );
            },
          ),
          BlocBuilder<MainScreenBloc, MainScreenState>(
            builder: (BuildContext context, MainScreenState state) {
              if (state is MainScreenLoadState) {
                return _body(state, context);
              }
              return Positioned(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  color: Colors.black12,
                  child: SpinKitDoubleBounce(
                    color: Colors.red,
                    size: 50.0,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _body(MainScreenLoadState state, BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _getBody(state, context),
        Positioned(
          bottom: MediaQuery.of(context).padding.bottom,
          left: 0,
          right: 0,
          top: 0,
          child: RadialMenu(
            onTapMenu: (index) {
              if (index == 5) {
                Navigator.push(
                  context,
                  PageTransition(
                    child: ForumScreen(
                      screenBloc: BlocProvider.of<MainScreenBloc>(context),
                    ),
                    type: PageTransitionType.fade,
                  ),
                );
              } else {
                BlocProvider.of<MainScreenBloc>(context).add(UpdateScreenEvent(screenIndex: index));
              }
            },
          ),
        ),
        BlocBuilder<ChallengeBloc, ChallengeState>(
          builder: (BuildContext ctx, ChallengeState challengeState) {
            print('Challenge List: ${challengeState.challengeList}');
            print('pendingRequestList List: ${challengeState.pendingRequestList}');
            print('receivedRequestList List: ${challengeState.receivedRequestList}');
            print('liveChallengeResultList List: ${challengeState.liveChallengeResultList}');
            print('liveChallenge: ${challengeState.liveChallenge}');
            print('liveChallengeList List: ${challengeState.liveChallengeList}');
            print('scheduleChallengeList List: ${challengeState.scheduleChallengeList}');
            print('scheduleChallengeRequestList List: ${challengeState.scheduleChallengeResultList}');
            print('scheduleChallenge: ${challengeState.scheduleChallenge}');
            if (challengeState.receivedRequestList.length > 0) {
              ChallengeModel model = challengeState.receivedRequestList.first;
              return FutureBuilder(
                future: FirestoreService().getUserWithId(model.sender),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Container();
                  }
                  return Positioned(
                    top: 24,
                    right: 8,
                    child: CustomPaint(
                      painter: PulseWidget(_controller),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext cctx) {
                              return GameRequestedScreen(
                                userModel: snapshot.data,
                                challengeModel: model,
                                onProfile: () {
                                  Navigator.push(
                                    cctx,
                                    PageTransition(
                                      child: OtherUserProfileScreen(
                                        userModel: snapshot.data,
                                        screenBloc: BlocProvider.of<MainScreenBloc>(context),
                                      ),
                                      type: PageTransitionType.fade,
                                      duration: Duration(milliseconds: 300),
                                    ),
                                  );
                                },
                                onAccept: () async {
                                  Navigator.pop(cctx);
                                  if (challengeState.receivedRequestList.length > 0) {
                                    DateTime dateTime = challengeState.receivedRequestList.first.challengeTime;
                                    Duration duration = DateTime.now().difference(dateTime);
                                    int seconds = (duration.inSeconds - 120);
                                    if (seconds < 0) {
                                      BlocProvider.of<ChallengeBloc>(context)..add(
                                        ResponseChallengeRequestEvent(
                                          challengeModel: model,
                                          response: 'accept',
                                        ),
                                      );
                                    }
                                  }
                                },
                                onDecline: () {
                                  Navigator.pop(cctx);
                                  if (challengeState.receivedRequestList.length > 0) {
                                    DateTime dateTime = challengeState.receivedRequestList.first.challengeTime;
                                    Duration duration = DateTime.now().difference(dateTime);
                                    int seconds = (duration.inSeconds - 120);
                                    if (seconds < 0) {
                                      BlocProvider.of<ChallengeBloc>(context).add(
                                        ResponseChallengeRequestEvent(
                                          challengeModel: model,
                                          response: 'decline',
                                        ),
                                      );
                                    }
                                  }
                                },
                              );
                            },
                          );
                        },
                        child: Container(
                          width: 64.0,
                          height: 64.0,
                          child: Center(
                            child: SizedBox(
                              width: 44,
                              height: 44,
                              child: ProfileAvatar(
                                image: snapshot.data.image ?? '',
                                avatarSize: 50,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (challengeState.pendingRequestList.length > 0) {
              ChallengeModel model = challengeState.pendingRequestList.first;
              return FutureBuilder(
                future: FirestoreService().getUserWithId(model.sender),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Container();
                  }
                  return Positioned(
                    top: 24,
                    right: 8,
                    child: CustomPaint(
                      painter: PulseWidget(_controller),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext cctx) {
                              return ChallengePendingDialog(
                                challengeModel: model,
                                onChallenge: () {
                                  Navigator.pop(context);
                                },
                                onSchedule: () {
                                  Navigator.pop(context);
                                },
                                onLive: () {
                                  Navigator.pop(context);
                                },
                              );
                            },
                          );
                        },
                        child: Container(
                          width: 64.0,
                          height: 64.0,
                          child: Center(
                            child: SizedBox(
                              width: 44,
                              height: 44,
                              child: ProfileAvatar(
                                image: snapshot.data.image ?? '',
                                avatarSize: 50,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return Container();
          },
        ),
        BlocBuilder<GameBloc, GameState>(
          builder: (BuildContext ctx, GameState gstate) {
            if (gstate is GameInState) {
              if (gstate.challengeModel != null) {
                ChallengeModel model = gstate.challengeModel;
                print(gstate.startTime);
                return FutureBuilder(
                  future: FirestoreService().getUserWithId(model.sender),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return Container();
                    }
                    UserModel user = snapshot.data;
                    return Positioned(
                      top: 24,
                      right: 8,
                      child: CustomPaint(
                        painter: PulseWidget(_controller),
                        child: GestureDetector(
                          onTap: () {
                            print(gstate.startTime);
                            Navigator.push(
                              context,
                              PageTransition(
                                child: GameInScreen(
                                  challengeModel: model,
                                  userModel: user,
                                  startTime: gstate.startTime,
                                ),
                                type: PageTransitionType.fade,
                              ),
                            );
                          },
                          child: Container(
                            width: 64.0,
                            height: 64.0,
                            child: Center(
                              child: SizedBox(
                                width: 44,
                                height: 44,
                                child: ProfileAvatar(
                                  image: snapshot.data.image ?? '',
                                  avatarSize: 50,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            }
            return Container();
          },
        ),
        state.isLoading ? Positioned(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Container(
            color: Colors.black12,
            child: SpinKitDoubleBounce(
              color: Colors.red,
              size: 50.0,
            ),
          ),
        ): Container()
      ],
    );
  }

  Widget _getBody(MainScreenLoadState state , BuildContext context) {
    Global.instance.homeContext = context;
    switch(state.currentScreen) {
      case 1:
        return StatsScreen(
          screenBloc: BlocProvider.of<MainScreenBloc>(context),
        );
      case 2:
        return FriendsScreen(
          homeContext: context,
          screenBloc: BlocProvider.of<MainScreenBloc>(context),
        );
      case 3:
        return CelebrityChallengeScreen(
          homeContext: context,
          screenBloc: BlocProvider.of<MainScreenBloc>(context),
        );
      case 4:
        return HomeScreen(
          homeContext: context,
          screenBloc: BlocProvider.of<MainScreenBloc>(context),
        );
      case 5:
        return ForumScreen(
          screenBloc: BlocProvider.of<MainScreenBloc>(context),
        );
      case 6:
        return ChatListScreen(
          homeContext: context,
          screenBloc: BlocProvider.of<MainScreenBloc>(context),
        );
      case 7:
        return SettingsScreen(
          homeContext: context,
          screenBloc: BlocProvider.of<MainScreenBloc>(context),
        );
    }
    return HomeScreen(
      homeContext: context,
      screenBloc: BlocProvider.of<MainScreenBloc>(context),
    );
  }

  Future<void> _initAdMob() {
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId, analyticsEnabled: true);
  }

}
