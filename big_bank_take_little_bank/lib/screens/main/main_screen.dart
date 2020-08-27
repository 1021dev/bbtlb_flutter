
import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/screens/main/daily_rewards/daily_rewards_screen.dart';
import 'package:big_bank_take_little_bank/screens/main/friends/friends_screen.dart';
import 'package:big_bank_take_little_bank/screens/main/home/home_screen.dart';
import 'package:big_bank_take_little_bank/screens/main/settings/settings_screen.dart';
import 'package:big_bank_take_little_bank/screens/main/stats/stats_screen.dart';
import 'package:big_bank_take_little_bank/utils/app_color.dart';
import 'package:big_bank_take_little_bank/widgets/radial_menu.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver{
  final GlobalKey<CircularMenuState> key = GlobalKey<CircularMenuState>();
  // ignore: close_sinks
  final MainScreenBloc mainScreenBloc = MainScreenBloc(MainScreenInitState());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      mainScreenBloc.add(UserOnlineEvent());
    } else {
      mainScreenBloc.add(UserOfflineEvent());
    }
    //TODO: set status to offline here in firestore
  }

  @override
  Widget build(BuildContext buildContext) {
    // ignore: close_sinks
    final DailyRewardsBloc dailyRewardsBloc = DailyRewardsBloc(DailyRewardsInitState());
    // ignore: close_sinks
    final MainScreenBloc mainScreenBloc = MainScreenBloc(MainScreenInitState());
    // ignore: close_sinks
    final AdsRewardsBloc adsRewardsBloc = AdsRewardsBloc(AdsRewardsInitState());
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

class _MainScreenContentState extends State<MainScreenContent> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset('assets/images/bg_home.png', fit: BoxFit.fill,),
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
              BlocProvider.of<MainScreenBloc>(context).add(UpdateScreenEvent(screenIndex: index));
            },
          ),
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
    print(state.currentScreen);
    switch(state.currentScreen) {
      case 1:
        return StatsScreen(
          screenBloc: BlocProvider.of<MainScreenBloc>(context),
        );
      case 2:
        return FriendsScreen(
          screenBloc: BlocProvider.of<MainScreenBloc>(context),
        );
      case 3:
        return Container();
      case 4:
        return HomeScreen(
          screenBloc: BlocProvider.of<MainScreenBloc>(context),
        );
      case 5:
        return Container();
      case 6:
        return Container();
      case 7:
        return SettingsScreen(
          screenBloc: BlocProvider.of<MainScreenBloc>(context),
        );
    }
    return HomeScreen(
      screenBloc: BlocProvider.of<MainScreenBloc>(context),
    );
  }

}
