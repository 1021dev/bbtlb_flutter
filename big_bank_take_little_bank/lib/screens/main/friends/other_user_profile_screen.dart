import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/models/block_model.dart';
import 'package:big_bank_take_little_bank/models/friends_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:big_bank_take_little_bank/screens/main/challenge/challenge_pending_screen.dart';
import 'package:big_bank_take_little_bank/screens/main/challenge/choose_challenge_screen.dart';
import 'package:big_bank_take_little_bank/screens/main/profile/add_points_screen.dart';
import 'package:big_bank_take_little_bank/screens/main/profile/gallery_screen.dart';
import 'package:big_bank_take_little_bank/widgets/animated_button.dart';
import 'package:big_bank_take_little_bank/widgets/app_button.dart';
import 'package:big_bank_take_little_bank/widgets/app_text.dart';
import 'package:big_bank_take_little_bank/widgets/background_widget.dart';
import 'package:big_bank_take_little_bank/widgets/profile_image_view.dart';
import 'package:big_bank_take_little_bank/widgets/stripe_widget.dart';
import 'package:big_bank_take_little_bank/widgets/title_background_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';

class OtherUserProfileScreen extends StatefulWidget {
  final MainScreenBloc screenBloc;
  final UserModel userModel;
  final FriendsModel friendsModel;
  OtherUserProfileScreen({Key key, this.screenBloc, this.userModel, this.friendsModel}) : super(key: key);

  @override
  _OtherUserProfileScreenState createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen>  with SingleTickerProviderStateMixin {

  FriendsBloc friendsBloc;
  bool isHelp = false;
  AnimationController controller;
  Animation<double> translation;
  Animation<double> scaleAnim;
  CurvedAnimation curvedAnimation;
  UserModel userModel;
  @override
  void initState() {
    super.initState();
    friendsBloc = FriendsBloc(FriendsInitState(userModel: widget.userModel));
    controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    curvedAnimation =
        CurvedAnimation(parent: controller, curve: Curves.bounceInOut);
    scaleAnim = Tween(begin: 0.0, end: 1.0).animate(controller)..addListener(() { setState(() {

    });});
    if (widget.userModel == null) {
      friendsBloc.add(LoadOtherUserProfile(friendId: widget.friendsModel.id));
    } else {
      userModel = widget.userModel;
      friendsBloc.add(LoadFriends(friendId: userModel.id));
    }
  }

  @override
  void dispose() {
    controller.dispose();
    friendsBloc.close();
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
        } else if (state is FriendsLoadState) {
          userModel = state.userModel;
        }
      },
      child: BlocBuilder<FriendsBloc, FriendsState>(
        cubit: friendsBloc,
        builder: (BuildContext context, FriendsState state) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg_other_user.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: _body(state),
            ),
          );
        },
      ),
    );
  }

  Widget _body(FriendsState state) {
    double avatarSize = MediaQuery.of(context).size.width * 0.3;
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: Image.asset('assets/images/bg_top.png', fit: BoxFit.fill,),
        ),
        SafeArea(
          top: false,
          bottom: false,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: double.infinity,
            padding: EdgeInsets.only(left: 8, right: 8),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 64, top: 44),
              child: Column(
                children: [
                  SizedBox(height: 16,),
                  Container(
                    height: avatarSize,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/bg_avatar.png',
                            width: avatarSize,
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(right: 4, bottom: 4),
                            child: ProfileImageView(
                              imageUrl: userModel != null ? userModel.image ?? '': '',
                              avatarSize: avatarSize - 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16,),
                  Text(
                    userModel != null ? userModel.name ?? '': '',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: 'BackToSchool'
                    ),
                  ),
                  SizedBox(height: 8,),
                  _buttons(state),
                  SizedBox(height: 8,),
                  _badgeSection(state),
                  SizedBox(
                    height: 16,
                  ),
                  _detailSection(state),
                  SizedBox(
                    height: 16,
                  ),
                  _challengesSection(state),
                  SizedBox(
                    height: 16,
                  ),
                  _galleryButton(state),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 44,
          left: 8,
          width: 44,
          height: 44,
          child: MaterialButton(
            child: Image.asset('assets/images/ic_back.png', ),
            shape: CircleBorder(),
            minWidth: 0,
            padding: EdgeInsets.zero,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        (state is FriendsLoadState) ?  Positioned(
          top: 44,
          right: 16,
          width: 55,
          height: 55,
          child: MaterialButton(
            child: getFriendImage(state.friendsModel, state.blockModel),
            shape: CircleBorder(),
            minWidth: 0,
            padding: EdgeInsets.zero,
            onPressed: () {
              if (state.friendsModel.status == 'pending') {
                if (state.friendsModel.sender == Global.instance.userId) {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) => CupertinoActionSheet(
                      title: Text('You sent Friend request'),
                      message: const Text('Your options are '),
                      actions: <Widget>[
                        CupertinoActionSheetAction(
                          child: const Text('Cancel Friend Request'),
                          onPressed: () {
                            Navigator.pop(context, 'cancel');
                            friendsBloc.add(CancelFriends(friendsModel: state.friendsModel));
                          },
                        ),
                        CupertinoActionSheetAction(
                          child: const Text('Block this User'),
                          onPressed: () {
                            Navigator.pop(context, 'block');
                            BlockModel blockModel = BlockModel(
                              id: state.friendsModel.id,
                              sender: state.friendsModel.sender,
                              receiver: state.friendsModel.receiver,
                              status: 'block',
                            );
                            friendsBloc.add(BlockFriends(blockModel: blockModel));
                          },
                        ),
                      ],
                      cancelButton: CupertinoActionSheetAction(
                        child: const Text('Cancel'),
                        isDefaultAction: true,
                        onPressed: () {
                          Navigator.pop(context, 'Cancel');
                        },
                      ),
                    ),
                  );
                } else {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) => CupertinoActionSheet(
                      title: const Text('Friends Request Received'),
                      message: const Text('Your options are '),
                      actions: <Widget>[
                        CupertinoActionSheetAction(
                          child: const Text('Accept Friends'),
                          onPressed: () {
                            Navigator.pop(context, 'accept');
                            friendsBloc.add(AcceptFriends(friendsModel: state.friendsModel));
                          },
                        ),
                        CupertinoActionSheetAction(
                          child: const Text('Reject Friends'),
                          onPressed: () {
                            Navigator.pop(context, 'decline');
                            friendsBloc.add(DeclineFriends(friendsModel: state.friendsModel));
                          },
                        ),
                        CupertinoActionSheetAction(
                          child: const Text('Block this User'),
                          onPressed: () {
                            Navigator.pop(context, 'decline');
                            BlockModel blockModel = BlockModel(
                              id: state.friendsModel.id,
                              sender: state.friendsModel.receiver,
                              receiver: state.friendsModel.sender,
                              status: 'block',
                            );
                            friendsBloc.add(BlockFriends(blockModel: blockModel));
                          },
                        ),
                      ],
                      cancelButton: CupertinoActionSheetAction(
                        child: const Text('Cancel'),
                        isDefaultAction: true,
                        onPressed: () {
                          Navigator.pop(context, 'Cancel');
                        },
                      ),
                    ),
                  );

                }
              } else if (state.friendsModel.status == 'accept') {
                showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) => CupertinoActionSheet(
                    title: Text('${userModel.name} is your Friend now.'),
                    message: const Text('Your options are '),
                    actions: <Widget>[
                      CupertinoActionSheetAction(
                        child: const Text('UnFriend this User'),
                        onPressed: () {
                          Navigator.pop(context, 'remove');
                          friendsBloc.add(CancelFriends(friendsModel: state.friendsModel));
                        },
                      ),
                      CupertinoActionSheetAction(
                        child: const Text('Block this User'),
                        onPressed: () {
                          Navigator.pop(context, 'remove');
                          BlockModel blockModel = BlockModel(
                            id: state.friendsModel.id,
                            sender: Global.instance.userId,
                            receiver: state.userModel.id,
                            status: 'block',
                          );
                          friendsBloc.add(BlockFriends(blockModel: blockModel));
                        },
                      ),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      child: const Text('Cancel'),
                      isDefaultAction: true,
                      onPressed: () {
                        Navigator.pop(context, 'Cancel');
                      },
                    ),
                  ),
                );
              } else if (state.friendsModel.status == 'decline') {
                if (state.friendsModel.sender == Global.instance.userId) {
                  return;
                }
                showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) => CupertinoActionSheet(
                    title: Text('You rejected ${userModel.name}\'s Friend request'),
                    message: const Text('Your options are '),
                    actions: <Widget>[
                      CupertinoActionSheetAction(
                        child: const Text('Add Friends'),
                        onPressed: () {
                          Navigator.pop(context, 'add');
                          friendsBloc.add(AcceptFriends(friendsModel: state.friendsModel));
                        },
                      ),
                      CupertinoActionSheetAction(
                        child: const Text('Block this User'),
                        onPressed: () {
                          Navigator.pop(context, 'remove');
                          BlockModel blockModel = BlockModel(
                            id: state.friendsModel.id,
                            sender: Global.instance.userId,
                            receiver: state.userModel.id,
                            status: 'block',
                          );
                          friendsBloc.add(BlockFriends(blockModel: blockModel));
                        },
                      ),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      child: const Text('Cancel'),
                      isDefaultAction: true,
                      onPressed: () {
                        Navigator.pop(context, 'Cancel');
                      },
                    ),
                  ),
                );
              } else {
                friendsBloc.add(RequestFriends(userModel: userModel));
              }
            },
          ),
        ): Container(),
        state is FriendsInitState ? Positioned(
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

  Widget _buttons(FriendsState state) {
    if (state is FriendsLoadState) {
      if (state.blockModel != null && state.blockModel.id != null){
        if (state.blockModel.sender == Global.instance.userId) {
          return Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                AppLabel(
                  title: 'You blocked this person',
                  fontSize: 14,
                  color: Color(0xffd40b22),
                  shadow: true,
                ),
                SizedBox(height: 16,),
                Row(
                  children: [
                    Flexible(
                      child: Container(),
                    ),
                    SizedBox(width: 16,),
                    Flexible(
                      child: AnimatedButton(
                        onTap: () {
                          friendsBloc.add(UnBlockFriends(blockModel: state.blockModel));
                        },
                        content: Container(
                          child:  AppButton(
                            colorStyle: 'green',
                            titleWidget: Image.asset('assets/images/ic_check_outline.png'),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16,),
                    Flexible(
                      child: Container(),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return Container(
            child: AppLabel(
              title: 'You are blocked from this person',
              fontSize: 14,
              color: Color(0xffd40b22),
              shadow: true,
            ),
          );
        }
      }
    }
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Flexible(
            child: AnimatedButton(
              onTap: () {

              },
              content: Container(
                child:  AppButton(
                  colorStyle: 'blue',
                  titleWidget: Image.asset('assets/images/ic_message_outline.png'),
                ),
              ),
            ),
          ),
          SizedBox(width: 16,),
          Flexible(
            child: AnimatedButton(
              onTap: () {
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
                                  homeContext: Global.instance.homeContext,
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
              content: Container(
                child:  AppButton(
                  colorStyle: 'yellow',
                  titleWidget: Image.asset('assets/images/ic_vs.png'),
                ),
              ),
            ),
          ),
          SizedBox(width: 16,),
          Flexible(
            child: AnimatedButton(
              onTap: () {
                if (state is FriendsLoadState) {
                  BlockModel blockModel = BlockModel(
                    id: state.userModel.id,
                    sender: Global.instance.userId,
                    receiver: state.userModel.id,
                    status: 'block',
                  );
                  friendsBloc.add(BlockFriends(blockModel: blockModel));
                }
              },
              content: Container(
                child:  AppButton(
                  colorStyle: 'red',
                  titleWidget: Image.asset('assets/images/ic_block.png'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badgeSection(FriendsState state) {
    return SizedBox(
      height: 250,
      child: Stack(
        alignment: Alignment.topCenter,
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 52,
            bottom: 0,
            left: 0,
            right: 0,
            child: BackgroundWidget(
              height: 200,
            ),
          ),
          Positioned(
            top: 25,
            height: 64,
            width: 160,
            child: TitleBackgroundWidget(
              title: 'BADGES',
              height: 64,
            ),
          ),
          Positioned(
            top: 0,
            height: 50,
            width: 190,
            child: Align(
              alignment: Alignment.topRight,
              child: Image.asset('assets/images/level_1_user_profile.png', width: 50, height: 50, fit: BoxFit.fill,),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailSection(FriendsState state) {
    return SizedBox(
      height: 320,
      child: Stack(
        alignment: Alignment.topCenter,
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            bottom: 50,
            left: 0,
            right: 0,
            child: BackgroundWidget(
              height: 300,
            ),
          ),
          Positioned(
            top: 16,
            left: 0,
            right: 0,
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color(0x60000000),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/level_1_challenger.png',
                            width: 32,
                            height: 32,
                            fit: BoxFit.fill,
                          ),
                          Image.asset(
                            'assets/images/hammer_im.png',
                            width: 24,
                            height: 24,
                            fit: BoxFit.fill,
                          ),
                        ],
                      ),
                      SizedBox(height: 8,),
                      Text(
                        userModel != null ? '${userModel.totalWin}': '',
                        style: TextStyle(
                          color: Color(0xFF84B65B),
                          fontSize: 20,
                          fontFamily: 'Lucky',
                        ),
                      ),
                      SizedBox(height: 8,),
                      Flexible(
                        child: Text(
                          'WINS',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 24,),
                Container(
                  width: 80,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color(0x60000000),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        userModel != null ? '${userModel.totalGamePlayed}': '',
                        style: TextStyle(
                          color: Color(0xFF3AC3DC),
                          fontSize: 32,
                          fontFamily: 'Lucky',
                        ),
                      ),
                      SizedBox(height: 4,),
                      Text(
                        'GAMES\nPLAYED',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 24,),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color(0x60000000),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(
                            'assets/images/hammer_im.png',
                            width: 24,
                            height: 24,
                            fit: BoxFit.fill,
                          ),
                          Image.asset(
                            'assets/images/lossing_piggy.png',
                            width: 32,
                            height: 32,
                            fit: BoxFit.fill,
                          ),
                        ],
                      ),
                      SizedBox(height: 8,),
                      Text(
                        userModel != null ? '${userModel.totalLoss}': '',
                        style: TextStyle(
                          color: Color(0xFFD741D9),
                          fontSize: 20,
                          fontFamily: 'Lucky',
                        ),
                      ),
                      SizedBox(height: 8,),
                      Flexible(
                        child: Text(
                          'LOSSES',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 152,
            height: 72,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0x60000000),
              ),
              padding: EdgeInsets.only(left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Age',
                        style: TextStyle(
                          color: Color(0xFF73878B),
                          fontSize: 18,
                          fontFamily: 'Cavier-Bold',
                        ),
                      ),
                      SizedBox(height: 8,),
                      Text(
                        userModel != null ? '${userModel.age}': '',
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 18,
                          fontFamily: 'BackToSchool',
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Container(
                      width: 1,
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Location',
                        style: TextStyle(
                          color: Color(0xFF73878B),
                          fontSize: 18,
                          fontFamily: 'Cavier-Bold',
                        ),
                      ),
                      SizedBox(height: 8,),
                      Text(
                        userModel != null ? userModel.location ?? '': '',
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 18,
                          fontFamily: 'BackToSchool',
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Container(
                      width: 1,
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Profession',
                        style: TextStyle(
                          color: Color(0xFF73878B),
                          fontSize: 18,
                          fontFamily: 'Cavier-Bold',
                        ),
                      ),
                      SizedBox(height: 8,),
                      Text(
                        userModel != null ? userModel.profession ?? '': '',
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 18,
                          fontFamily: 'BackToSchool',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _challengesSection(FriendsState state) {
    double progress = 0.0;
    if (userModel != null) {
      if (userModel.totalRequest == 0 && userModel.totalDeclined == 0) {
        progress = 0;
      } else {
        progress = MediaQuery.of(context).size.width * 0.6 * userModel.totalRequest.toDouble() / (userModel.totalRequest.toDouble() + userModel.totalDeclined.toDouble());
  }
}
    return SizedBox(
      height: 200,
      child: Stack(
        alignment: Alignment.topCenter,
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 24,
            bottom: 0,
            left: 0,
            right: 0,
            child: BackgroundWidget(
              height: 200,
            ),
          ),
          Positioned(
            top: 0,
            height: 64,
            width: 160,
            child: TitleBackgroundWidget(
              title: 'CHALLENGES',
              height: 64,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 16,),
                  Text(
                    userModel != null ? '${userModel.totalRequest}': '0',
                    style: TextStyle(
                      color: Color(0xFF19DC47),
                      fontSize: 32,
                      fontFamily: 'Lucky',
                    ),
                  ),
                  SizedBox(height: 8,),
                  Text(
                    'REQUESTED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Lucky',
                      shadows: [
                        Shadow(
                          color: Colors.black87,
                          offset: Offset(4.0, 4.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(width: 24,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 16,),
                  Text(
                    userModel != null ? '${userModel.totalDeclined}': '0',
                    style: TextStyle(
                      color: Color(0xFFF3422E),
                      fontSize: 32,
                      fontFamily: 'Lucky',
                    ),
                  ),
                  SizedBox(height: 8,),
                  Text(
                    'DECLINED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Lucky',
                      shadows: [
                        Shadow(
                          color: Colors.black87,
                          offset: Offset(4.0, 4.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 24,
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 24,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: (userModel != null ? userModel.totalDeclined : 0) > 0 ? [
                        Color(0xffc93900),
                        Color(0xffff443b),
                      ]: [
                        Color(0xff0b3935),
                        Color(0xff185458),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(12),
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
                      borderRadius: BorderRadius.circular(12),
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
                      borderRadius: BorderRadius.circular(12),
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
          )
        ],
      ),
    );
  }

  Widget _galleryButton(FriendsState state) {
    if (state is FriendsLoadState) {
      if (state.blockModel != null && state.blockModel.id != null){
        return Container();
      }
    }
    return Container(
      height: 55,
      width: 725 / 175 * 55,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: Image.asset(
            'assets/images/btn_gallery.png',
            width: 725 / 175 * 55,
            height: 55,
            fit: BoxFit.fill,
          ).image,
        ),
      ),
      child: SizedBox.expand(
        child: MaterialButton(
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                child: GalleryScreen(
                  userModel: userModel,
                ),
                type: PageTransitionType.fade,
                duration: Duration(microseconds: 300),
              ),
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minWidth: 0,
          height: 50,
          padding: EdgeInsets.all(0),
        ),
      ),
    );
  }

  Image getFriendImage(FriendsModel friendsModel, BlockModel blockModel) {
    if (blockModel != null && blockModel.id != null) {
      return null;
    }
    if (friendsModel == null) {
      return null;
    }
    switch (friendsModel.status) {
      case 'notFriends':
        return Image.asset('assets/images/friend_add.png');
        break;
      case 'pending':
        if (friendsModel.sender == FirebaseAuth.instance.currentUser.uid) {
          return Image.asset('assets/images/friend_pending.png');
        } else {
          return Image.asset('assets/images/friend_waiting.png');
        }
        break;
      case 'accept':
        if (friendsModel.sender == FirebaseAuth.instance.currentUser.uid) {
          return Image.asset('assets/images/friend_sent.png');
        } else {
          return Image.asset('assets/images/friend_sent.png');
        }
        break;
      case 'decline':
        if (friendsModel.sender == FirebaseAuth.instance.currentUser.uid) {
          return Image.asset('assets/images/friend_reject.png');
        } else {
          return Image.asset('assets/images/friend_remove.png');
        }
        break;
      case 'block':
        if (friendsModel.sender == FirebaseAuth.instance.currentUser.uid) {
          return Image.asset('assets/images/friend_remove.png');
        } else {
          return Image.asset('assets/images/friend_remove.png');
        }
        break;
      default:
        return Image.asset('assets/images/friend_add.png');
    }
  }
}
