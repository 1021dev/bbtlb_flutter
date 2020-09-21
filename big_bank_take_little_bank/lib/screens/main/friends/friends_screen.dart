import 'dart:math';

import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/models/friends_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:big_bank_take_little_bank/screens/main/challenge/challenge_pending_screen.dart';
import 'package:big_bank_take_little_bank/screens/main/challenge/choose_challenge_screen.dart';
import 'package:big_bank_take_little_bank/screens/main/friends/friends_cell.dart';
import 'package:big_bank_take_little_bank/screens/main/profile/add_points_screen.dart';
import 'package:big_bank_take_little_bank/widgets/app_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:page_transition/page_transition.dart';

import 'friends_request_cell.dart';
import 'other_user_profile_screen.dart';

class FriendsScreen extends StatefulWidget {
  final MainScreenBloc screenBloc;
  final BuildContext homeContext;
  FriendsScreen({Key key, this.screenBloc, this.homeContext,}) : super(key: key);

  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final FriendsBloc friendsBloc = FriendsBloc(FriendsInitState());

  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    friendsBloc.add(LoadFriendsList());
    super.initState();
  }

  @override
  void dispose() {
    friendsBloc.close();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: friendsBloc,
      listener: (BuildContext context, FriendsState state) async {
        if (state is FriendsSuccess) {
        } else if (state is FriendsFailure) {
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
      child: BlocBuilder<FriendsBloc, FriendsState>(
        cubit: friendsBloc,
        builder: (BuildContext context, FriendsState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _body(FriendsState state) {
    double itemWidth = ((MediaQuery.of(context).size.width - 56) / 2);
    double itemHeight = itemWidth / 526 * 624;
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: Image.asset('assets/images/bg_top_bar_trans.png', fit: BoxFit.fill,),
        ),
        SafeArea(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 24,
                width: MediaQuery.of(context).size.width * 0.6,
                child: Image.asset('assets/images/ic_friends_header.png',),
              ),
              (state is FriendsListLoadState) ? Positioned(
                top: 124,
                left: 24,
                right: 24,
                bottom: 24,
                child: state.friendsGroupList.length > 0 ? _friendsListWidget(state): Center(
                  child: AppLabel(
                    title: 'Currently you don\'t have any friends',
                  ),
                ),
              ): Container(),
            ],
          ),
        ),
        // Positioned(
        //   height: MediaQuery.of(context).size.height,
        //   width: MediaQuery.of(context).size.width,
        //   child: Container(
        //     color: Colors.black12,
        //     child: SpinKitDoubleBounce(
        //       color: Colors.red,
        //       size: 50.0,
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _friendsListWidget(FriendsListLoadState state) {
    return Container(
      child: Column(
        children: [
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
                          hintText: 'Search friends'
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
            child: GroupedListView<FriendsGroupModel, String>(
              padding: EdgeInsets.only(bottom: 100),
              groupBy: (element) => element.group,
              elements: state.friendsGroupList,
              order: GroupedListOrder.ASC,
              useStickyGroupSeparators: false,
              floatingHeader: true,
              groupSeparatorBuilder: (String value) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppButtonLabel(
                  title: value == '' ? 'Friends Requests' : value,
                  shadow: true,
                  fontSize: 24,
                ),
              ),
              itemBuilder: (c, element) {
                return element.group == '' ? FriendsRequestCell(
                  groupModel: element,
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: OtherUserProfileScreen(
                          screenBloc: widget.screenBloc,
                          friendsModel: element.friendsModel,
                        ),
                        type: PageTransitionType.downToUp,
                      ),
                    );
                  },
                  onAccept: () {
                    FriendsModel friendsModel = element.friendsModel;
                    friendsBloc.add(AcceptFriends(friendsModel: friendsModel));
                  },
                  onDecline: () {
                    FriendsModel friendsModel = element.friendsModel;
                    friendsBloc.add(DeclineFriends(friendsModel: friendsModel));
                  },
                )
                    :FriendsCell(
                  groupModel: element,
                  onTap: (UserModel userModel) {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: OtherUserProfileScreen(
                          screenBloc: widget.screenBloc,
                          friendsModel: element.friendsModel,
                        ),
                        type: PageTransitionType.downToUp,
                      ),
                    );
                  },
                  onChat: (UserModel userModel) {

                  },
                  onChallenge: (UserModel userModel) {
                    if (Global.instance.userModel.points == 0) {
                      showCupertinoDialog(context: context, builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          title: Text('Oops'),
                          content: AppLabel(
                            title: 'You don\'t have enough points',
                            alignment: TextAlign.center,
                            maxLine: 2,
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
                    } else if (userModel.points == 0) {
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
                    } else if (userModel.level != Global.instance.userModel.level) {
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
                            userModel: userModel,
                            onChallenge: () {
                              Navigator.pop(context);
                              BlocProvider.of<ChallengeBloc>(Global.instance.homeContext).add(
                                  RequestChallengeEvent(
                                    type: 'standard',
                                    userModel: userModel,
                                  )
                              );
                            },
                            onSchedule: () async {
                              final date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1900),
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
                                BlocProvider.of<ChallengeBloc>(Global.instance.homeContext).add(
                                    RequestChallengeEvent(
                                      type: 'schedule',
                                      challengeTime: dateValue.toDouble() + timeValue.toDouble(),
                                      userModel: userModel,
                                    )
                                );
                              } else {
                                print(date);
                              }
                              Navigator.pop(context);
                            },
                            onLive: () {
                              Navigator.pop(context);
                              BlocProvider.of<ChallengeBloc>(Global.instance.homeContext).add(
                                  RequestChallengeEvent(
                                    type: 'live',
                                    userModel: userModel,
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
          )
        ],
      ),
    );
  }

}
