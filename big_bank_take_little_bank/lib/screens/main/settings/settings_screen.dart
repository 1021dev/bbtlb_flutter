import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/screens/main/profile/profile_screen.dart';
import 'package:big_bank_take_little_bank/screens/main/settings/change_password_dialog.dart';
import 'package:big_bank_take_little_bank/screens/main/settings/invite_friends_screen.dart';
import 'package:big_bank_take_little_bank/screens/splash/splash_screen.dart';
import 'package:big_bank_take_little_bank/widgets/setting_cell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';

class SettingsScreen extends StatefulWidget {
  final MainScreenBloc screenBloc;
  SettingsScreen({Key key, this.screenBloc}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>  with SingleTickerProviderStateMixin {

  bool isHelp = false;
  AnimationController controller;
  Animation<double> translation;
  Animation<double> scaleAnim;
  CurvedAnimation curvedAnimation;

  // ignore: close_sinks
  ProfileScreenBloc profileScreenBloc;

  @override
  void initState() {
    profileScreenBloc = ProfileScreenBloc(ProfileScreenState(isLoading: true), mainScreenBloc: widget.screenBloc,);
    profileScreenBloc.add(ProfileScreenInitEvent());
    super.initState();
    controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    curvedAnimation =
        CurvedAnimation(parent: controller, curve: Curves.bounceInOut);
    scaleAnim = Tween(begin: 0.0, end: 1.0).animate(controller)..addListener(() { setState(() {

    });});

  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: profileScreenBloc,
      listener: (BuildContext context, ProfileScreenState state) async {
        if (state is ProfileScreenSuccess) {
          profileScreenBloc.add(ProfileScreenInitEvent());
        } else if (state is ProfileScreenFailure) {
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
        } else if (state is ProfileScreenLogout) {
          Navigator.pushReplacement(context, PageTransition(
            child: SplashScreen(),
            type: PageTransitionType.leftToRightWithFade,
            duration: Duration(microseconds: 500),
          ));
        }
      },
      child: BlocBuilder<ProfileScreenBloc, ProfileScreenState>(
        cubit: profileScreenBloc,
        builder: (BuildContext context, ProfileScreenState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _body(ProfileScreenState state) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: Image.asset('assets/images/bg_top.png',),
        ),
        SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/icon_setting.png',
                  width: MediaQuery.of(context).size.width * 0.6,
                ),
                SizedBox(height: 16,),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 64,),
                    child: Column(
                      children: [
                        SettingCellView(
                          icon: 'setting_pig',
                          text: 'Profile',
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: ProfileScreen(
                                  screenBloc: profileScreenBloc,
                                ),
                                type: PageTransitionType.fade,
                                duration: Duration(microseconds: 500),
                              ),
                            );
                          },
                        ),
                        SettingCellView(
                          icon: 'setting_pig',
                          text: 'Invite Friends',
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: InviteFriendsScreen(
                                  screenBloc: profileScreenBloc,
                                ),
                                type: PageTransitionType.fade,
                                duration: Duration(microseconds: 500),
                              ),
                            );
                          },
                        ),
                        SettingCellView(
                          icon: 'setting_lock',
                          text: 'CHANGE PASSWORD',
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ChangePasswordDialog(
                                  screenBloc: profileScreenBloc,
                                  userModel: state.currentUser,
                                );
                              },
                            );
                          },
                        ),
                        SettingCellView(
                          icon: 'setting_block',
                          text: 'BLOCKED',
                          onTap: () {

                          },
                        ),
                        SettingCellView(
                          icon: 'setting_notification',
                          text: 'NOTIFICATIONS',
                          notification: true,
                          onTap: () {

                          },
                          onChange: (val) {

                          },
                        ),
                        SettingCellView(
                          icon: 'setting_logout',
                          text: 'Logout',
                          onTap: () {
                            profileScreenBloc.add(ProfileScreenLogoutEvent());
                          },
                        ),
                        SettingCellView(
                          icon: 'setting_help',
                          text: 'HELP',
                          onTap: () {
                            setState(() {
                              isHelp = !isHelp;
                              if (!isHelp) {
                                controller.reverse();
                              } else {
                                controller.forward();
                              }
                            });
                          },
                        ),
                        isHelp ? SizedBox(
                          height: 8,
                        ): Container(),
                        isHelp ? Transform(
                          transform: Matrix4.identity()..scale(1.0, scaleAnim.value),
                          child: Column(
                              children: List.generate(helpStrings.length, (index) {
                                return Container(
                                  width: double.infinity,
                                  height: 50,
                                  margin: EdgeInsets.only(left: 24, right: 24),
                                  padding: EdgeInsets.only(left: 16),
                                  color: index % 2 == 0 ? Color(0xFF549383): Color(0xFF0E3D47),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      helpStrings[index],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'BackToSchool',
                                      ),
                                    ),
                                  ),
                                );
                              })
                          ),
                        ): Container(),
                        Container(
                          width: double.infinity,
                          height: 80,
                          margin: EdgeInsets.all(4),
                          child: MaterialButton(
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset('assets/images/btn_delete_bg.png',
                                  fit: BoxFit.fill,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 24, right: 24),
                                  child: Row(
                                    children: [
                                      Image.asset('assets/images/setting_delete.png', height: 50,),
                                      SizedBox(width: 16,),
                                      Text(
                                        'Delete Account',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Lucky',
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            minWidth: 0,
                            padding: EdgeInsets.zero,
                            onPressed: () {

                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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

List<String> helpStrings = [
  'Questions',
  'How To Play',
  'Problem',
  'Feedback',
  'Privacy Policy',
  'About',
];