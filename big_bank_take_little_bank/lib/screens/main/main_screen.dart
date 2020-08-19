import 'dart:math';

import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/screens/rigister/register_screen.dart';
import 'package:big_bank_take_little_bank/utils/app_color.dart';
import 'package:big_bank_take_little_bank/utils/app_helper.dart';
import 'package:big_bank_take_little_bank/widgets/radial_menu.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:oktoast/oktoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:toast/toast.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  MainScreenBloc screenBloc;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<CircularMenuState> key = GlobalKey<CircularMenuState>();

  @override
  void initState() {
    screenBloc = new MainScreenBloc(MainScreenState());
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
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(16),
        ),
        Positioned(
          bottom: MediaQuery.of(context).padding.bottom,
          left: 0,
          right: 0,
          top: 0,
          child: RadialMenu(
            onTapMenu: (index) {

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

}
