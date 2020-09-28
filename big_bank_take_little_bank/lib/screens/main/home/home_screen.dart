import 'dart:math';

import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:big_bank_take_little_bank/screens/main/challenge/challenge_pending_screen.dart';
import 'package:big_bank_take_little_bank/screens/main/challenge/choose_challenge_screen.dart';
import 'package:big_bank_take_little_bank/screens/main/friends/other_user_profile_screen.dart';
import 'package:big_bank_take_little_bank/screens/main/home/home_cell.dart';
import 'package:big_bank_take_little_bank/screens/main/live/live_challenge_screen.dart';
import 'package:big_bank_take_little_bank/screens/main/profile/add_points_screen.dart';
import 'package:big_bank_take_little_bank/screens/main/profile/profile_screen.dart';
import 'package:big_bank_take_little_bank/utils/app_helper.dart';
import 'package:big_bank_take_little_bank/widgets/app_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';

class HomeScreen extends StatefulWidget {
  final BuildContext homeContext;
  final MainScreenBloc screenBloc;
  HomeScreen({Key key, this.screenBloc, this.homeContext,}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    widget.screenBloc.add(MainScreenInitEvent());
    super.initState();
    searchController.addListener(() {
      widget.screenBloc.add(SearchUserEvent(query: searchController.text));
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: widget.screenBloc,
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
        cubit: widget.screenBloc,
        builder: (BuildContext context, MainScreenState state) {
          return SafeArea(
            child: _body(state),
          );
        },
      ),
    );
  }

  Widget _body(MainScreenLoadState state) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {

                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 4,
                            child: Image.asset(
                              'assets/images/btn_nearby.png',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 4,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: LiveChallengeScreen(
                                  screenBloc: widget.screenBloc,
                                  homeContext: widget.homeContext,
                                ),
                                type: PageTransitionType.fade,
                                duration: Duration(microseconds: 3000),
                              ),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 4,
                            child: Image.asset(
                              'assets/images/btn_live.png',
                              height: MediaQuery.of(context).size.width,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: ProfileScreen(
                            homeContext: widget.homeContext,
                            screenBloc: ProfileScreenBloc(ProfileScreenState(isLoading: true), mainScreenBloc: widget.screenBloc,)..add(ProfileScreenInitEvent()),
                          ),
                          type: PageTransitionType.fade,
                          duration: Duration(microseconds: 300),
                        ),
                      );
                    },
                    child: Container(
                      height: 100,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/images/bg_points.png',
                            width: MediaQuery.of(context).size.width / 3,
                          ),
                          Column(
                            children: [
                              Image.asset('assets/images/level_1_user_profile.png', width: 36,),
                              SizedBox(height: 4,),
                              Text(
                                state.currentUser != null ? '${state.currentUser.points}': '0',
                                style: TextStyle(
                                  fontFamily: 'BackToSchool',
                                  fontSize: 16,
                                  color: Color(0xffF39B27),
                                ),
                              ),
                              Text(
                                state.currentUser != null ? 'Level ${state.currentUser.level}': 'Level 1',
                                style: TextStyle(
                                  fontFamily: 'BackToSchool',
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                padding: EdgeInsets.only(left: 16,),
                height: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/bg_search_field.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Transform.rotate(
                  angle: -pi / 100.0,
                  child: Row(
                    children: [
                      Flexible(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search people'
                          ),
                          style: TextStyle(
                            fontFamily: 'BackToSchool',
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: (){

                        },
                        minWidth: 0,
                        shape: CircleBorder(),
                        height: 44,
                        child: Image.asset('assets/images/searchicon.png',
                          width: 32, height: 32,),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.6,
                  mainAxisSpacing: 16,
                  padding: EdgeInsets.only(bottom: 100, top: 16),
                  children: List.generate(
                    (searchController.text ?? '') == '' ? state.activeUsers.length: state.filterUsers.length,
                        (index) {
                      return HomeCell(
                        userModel: (searchController.text ?? '') == '' ? state.activeUsers[index]: state.filterUsers[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              child: OtherUserProfileScreen(
                                screenBloc: widget.screenBloc,
                                userModel: (searchController.text ?? '') == '' ? state.activeUsers[index]: state.filterUsers[index],
                              ),
                              type: PageTransitionType.downToUp,
                            ),
                          );
                        },
                        onChallenge: () {
                          if (Global.instance.userModel.points == 0) {
                            showCupertinoDialog(context: context, builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: Text('Oops'),
                                content: AppLabel(
                                  title: 'You don\'t have enough points',
                                  maxLine: 2,
                                  alignment: TextAlign.center,
                                ),
                                actions: [
                                  CupertinoDialogAction(
                                    child: Text('Get Points'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          child: AddPointsScreen(
                                            homeContext: widget.homeContext,
                                          ),
                                          type: PageTransitionType.fade,
                                          duration: Duration(microseconds: 300),
                                        ),
                                      );
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            });
                          } else if (((searchController.text ?? '') == '' ?  state.activeUsers[index].points: state.filterUsers[index]) == 0) {
                            showCupertinoDialog(context: context, builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: Text('Oops'),
                                content: AppLabel(
                                  title: 'You cannot game with this user',
                                ),
                                actions: [
                                  CupertinoDialogAction(
                                    child: Text('Ok'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            });
                          } else if (((searchController.text ?? '') == '' ? state.activeUsers[index].level: state.filterUsers[index].level) != Global.instance.userModel.level) {
                            showCupertinoDialog(context: context, builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: Text('Oops'),
                                content: AppLabel(
                                  title: 'You cannot game with this user',
                                ),
                                actions: [
                                  CupertinoDialogAction(
                                    child: Text('Ok'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            });
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                if (BlocProvider.of<ChallengeBloc>(Global.instance.homeContext).state.pendingRequestList.length > 0) {
                                  return ChallengePendingDialog(
                                    challengeModel: BlocProvider.of<ChallengeBloc>(Global.instance.homeContext).state.pendingRequestList.first,
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
                                } else if (BlocProvider.of<ChallengeBloc>(Global.instance.homeContext).state.receivedRequestList.length > 0) {
                                  return ChallengePendingDialog(
                                    challengeModel: BlocProvider.of<ChallengeBloc>(Global.instance.homeContext).state.receivedRequestList.first,
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
                                }
                                return ChooseChallengeScreen(
                                  userModel: (searchController.text ?? '') == '' ? state.activeUsers[index]: state.filterUsers[index],
                                  onChallenge: () {
                                    Navigator.pop(context);
                                    BlocProvider.of<ChallengeBloc>(widget.homeContext).add(
                                        RequestChallengeEvent(
                                          type: 'standard',
                                          userModel: (searchController.text ?? '') == '' ? state.activeUsers[index]: state.filterUsers[index],
                                        )
                                    );
                                  },
                                  onSchedule: () async {
                                    final date = await showDatePicker(
                                        context: context,
                                        firstDate: DateTime.now(),
                                        initialDate: DateTime.now(),
                                        lastDate: DateTime(2100));
                                    if (date != null) {
                                      final time = await showTimePicker(
                                        context: context,
                                        initialTime:
                                        TimeOfDay.fromDateTime(DateTime.now()),
                                      );
                                      print(date);
                                      print(time);
                                      int dateValue = date.millisecondsSinceEpoch;
                                      int timeValue = time.hour * 3600000 + time.minute * 60000;
                                      if (timeValue < DateTime.now().millisecondsSinceEpoch + 600000) {
                                        Navigator.pop(context);
                                        AppHelper.showMyDialog(context, 'The schedule time should be 10 minutes later than now.');
                                      } else {
                                        Navigator.pop(context);
                                        BlocProvider.of<ChallengeBloc>(widget.homeContext).add(
                                            RequestChallengeEvent(
                                              type: 'schedule',
                                              challengeTime: dateValue.toDouble() + timeValue.toDouble(),
                                              userModel: (searchController.text ?? '') == '' ? state.activeUsers[index]: state.filterUsers[index],
                                            )
                                        );
                                      }
                                    } else {
                                      Navigator.pop(context);
                                      AppHelper.showMyDialog(context, 'The schedule time should be 10 minutes later than now.');
                                    }
                                  },
                                  onLive: () {
                                    Navigator.pop(context);
                                    BlocProvider.of<ChallengeBloc>(widget.homeContext).add(
                                        RequestChallengeEvent(
                                          type: 'live',
                                          userModel: (searchController.text ?? '') == '' ? state.activeUsers[index]: state.filterUsers[index],
                                        )
                                    );
                                  },
                                );
                              },
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              )
            ],
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
