
import 'package:big_bank_take_little_bank/blocs/bloc.dart';
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

class _MainScreenState extends State<MainScreen> {
  MainScreenBloc screenBloc = MainScreenBloc(MainScreenState());
  final GlobalKey<CircularMenuState> key = GlobalKey<CircularMenuState>();

  @override
  void initState() {
    screenBloc.add(MainScreenInitEvent());
    super.initState();
  }

  @override
  void dispose() {
    screenBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: screenBloc,
      listener: (BuildContext context, MainScreenState state) async {
        if (state is LoginScreenSuccess) {
        } else if (state is MainScreenFailure) {
          showCupertinoDialog(context: context, builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text('Oops'),
              content: Text(state.error),
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
      child: BlocBuilder<MainScreenBloc, MainScreenState>(
        cubit: screenBloc,
        builder: (BuildContext context, MainScreenState state) {
          return Scaffold(
            backgroundColor: AppColor.background,
            resizeToAvoidBottomInset: true,
            body: _body(state),
          );
        },
      ),
    );
  }

  Widget _body(MainScreenState state) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Image.asset('assets/images/bg_home.png', fit: BoxFit.fill,),
        ),
        _getBody(state),
        Positioned(
          bottom: MediaQuery.of(context).padding.bottom,
          left: 0,
          right: 0,
          top: 0,
          child: RadialMenu(
            onTapMenu: (index) {
              screenBloc.add(UpdateScreenEvent(screenIndex: index));
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

  Widget _getBody(MainScreenState state) {
    print(state.currentScreen);
    switch(state.currentScreen) {
      case 1:
        return StatsScreen(
          screenBloc: screenBloc,
        );
      case 2:
        return FriendsScreen(
          screenBloc: screenBloc,
        );
      case 3:
        return Container();
      case 4:
        return HomeScreen(
          screenBloc: screenBloc,
        );
      case 5:
        return Container();
      case 6:
        return Container();
      case 7:
        return SettingsScreen(
          screenBloc: screenBloc,
        );
    }
    return HomeScreen(
      screenBloc: screenBloc,
    );
  }

}
