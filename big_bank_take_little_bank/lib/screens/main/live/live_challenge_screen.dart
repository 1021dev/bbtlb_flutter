
import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/models/challenge_model.dart';
import 'package:big_bank_take_little_bank/models/message_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:big_bank_take_little_bank/screens/main/challenge/game_in_screen.dart';
import 'package:big_bank_take_little_bank/screens/main/friends/other_user_profile_screen.dart';
import 'package:big_bank_take_little_bank/screens/main/live/message_cell.dart';
import 'package:big_bank_take_little_bank/screens/main/live/schedule_challenge_finished_cell.dart';
import 'package:big_bank_take_little_bank/screens/main/live/schedule_challenge_scheduled_cell.dart';
import 'package:big_bank_take_little_bank/widgets/app_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';

import 'live_challenge_finished_cell.dart';
import 'live_challenge_ongoing_cell.dart';

class LiveChallengeScreen extends StatefulWidget {
  final MainScreenBloc screenBloc;
  final BuildContext homeContext;
  LiveChallengeScreen({Key key, this.screenBloc, this.homeContext}) : super(key: key);

  @override
  _LiveChallengeScreenState createState() => _LiveChallengeScreenState();
}

class _LiveChallengeScreenState extends State<LiveChallengeScreen> {
  ChallengeBloc challengeBloc;
// a key to set on our Text widget, so we can measure later
  GlobalKey myTextKey = GlobalKey();
// a RenderBox object to use in state
  RenderBox myTextRenderBox;
  final TextEditingController messageController = new TextEditingController();
  final FocusNode messageFocus = new FocusNode();

  int currentChallengeType = 0;
  int currentIndex = 0;
  bool isPrivate = false;

  @override
  void initState() {
    challengeBloc = BlocProvider.of<ChallengeBloc>(Global.instance.homeContext);
    WidgetsBinding.instance.addPostFrameCallback((_) => _recordSize());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: challengeBloc,
      listener: (BuildContext context, ChallengeState state) async {
      },
      child: BlocBuilder<ChallengeBloc, ChallengeState>(
        cubit: challengeBloc,
        builder: (BuildContext context, ChallengeState state) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_home.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomPadding: true,
              resizeToAvoidBottomInset: true,
              body: _body(state),
            ),
          );
        },
      ),
    );
  }

  void _recordSize() {
    // now we set the RenderBox and trigger a redraw
    setState(() {
      myTextRenderBox = myTextKey.currentContext.findRenderObject();
    });
  }

  Widget _body(ChallengeState state) {
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
                top: 100,
                left: 8,
                right: 8,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/bg_stats.png',),
                      fit: BoxFit.fill,
                    )
                  ),
                  padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: Column(
                    children: [
                      Container(
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentIndex = 0;
                                });
                              },
                              child: Container(
                                height: 44,
                                width: MediaQuery.of(context).size.width * 0.35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: currentIndex == 0 ? Colors.black26 : Colors.transparent,
                                ),
                                child: Center(
                                  child: AppButtonLabel(
                                    title: currentChallengeType == 0 ? 'ONGOING': 'SCHEDULED',
                                    shadow: true,
                                    fontSize: 24,
                                    color: currentIndex == 0 ? Colors.white : Colors.white70,
                                    shadowColor: currentIndex == 0 ? Colors.black87 : Colors.black12,
                                    align: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentIndex = 1;
                                });
                              },
                              child: Container(
                                height: 44,
                                width: MediaQuery.of(context).size.width * 0.35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: currentIndex == 1 ? Colors.black26 : Colors.transparent,
                                ),
                                child: Center(
                                  child: AppButtonLabel(
                                    title: 'FINISHED',
                                    shadow: true,
                                    fontSize: 24,
                                    color: currentIndex == 1 ? Colors.white : Colors.white70,
                                    shadowColor: currentIndex == 1 ? Colors.black87 : Colors.black12,
                                    align: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      currentChallengeType == 0 && currentIndex == 1 ? Container(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: Container(
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xff194f5c),
                                            Color(0xff498f8b),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                        border: Border.all(
                                          color: Color(0xff14444f),
                                          width: 4,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black38,
                                            offset: Offset(4, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Transform.translate(
                                            offset: Offset(0, -16),
                                            child: Image.asset('assets/images/ic_pig_winner.png'),
                                          ),
                                          SizedBox(width: 8,),
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.bottomCenter,
                                              child: AppGradientLabel(
                                                title: 'WINNER',
                                                shadow: true,
                                                fontSize: 22,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 16,),
                            Flexible(
                              flex: 1,
                              child: Container(
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xffe81919),
                                            Color(0xffed5e3c),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                        border: Border.all(
                                          color: Color(0xffe9231e),
                                          width: 4,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black38,
                                            offset: Offset(4, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.bottomCenter,
                                              child: AppGradientLabel(
                                                title: 'LOSER',
                                                shadow: true,
                                                fontSize: 22,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8,),
                                          Transform.translate(
                                            offset: Offset(0, -16),
                                            child: Image.asset('assets/images/ic_pig_looser.png'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ): Container(),
                      Expanded(
                        child: _challengeListWidget(state)
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  children: [
                    Text(
                      'CHALLENGES',
                      key: myTextKey,
                      style: new TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()..shader = getTextGradient(myTextRenderBox),
                        letterSpacing: 2,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              currentChallengeType = 0;
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.35,
                            height: MediaQuery.of(context).size.width * 0.26,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/bg_rect.png'),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Opacity(
                                    opacity: currentChallengeType == 0 ? 1: 0.5,
                                    child: Image.asset('assets/images/ic_live.png', width: 32, height: 32,),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: AppButtonLabel(
                                    title: 'LIVE',
                                    shadow: true,
                                    fontSize: 18,
                                    color: currentChallengeType == 0 ? Colors.white : Colors.white60,
                                    shadowColor: currentChallengeType == 0 ? Colors.black87 : Colors.black38,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              currentChallengeType = 1;
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.35,
                            height: MediaQuery.of(context).size.width * 0.26,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/bg_rect.png'),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Opacity(
                                    opacity: currentChallengeType == 1 ? 1: 0.5,
                                    child: Image.asset('assets/images/ic_timer.png', width: 32, height: 32,),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: AppButtonLabel(
                                    title: 'SCHEDULED',
                                    shadow: true,
                                    fontSize: 18,
                                    color: currentChallengeType == 1 ? Colors.white : Colors.white60,
                                    shadowColor: currentChallengeType == 1 ? Colors.black87 : Colors.black38,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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
        state.isChatMode ? Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black45,
            ),
          ),
        ): Container(),
        state.isChatMode ? Positioned(
          top: MediaQuery.of(context).viewPadding.top,
          left: 0,
          right: 0,
          bottom: MediaQuery.of(context).viewPadding.bottom,
          child: SingleChildScrollView(
            child: _showChatView(state),
          ),
        ): Container(),
        state.isChatMode ? Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/bg_input_message.png'),
                    fit: BoxFit.fill
                ),
              ),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      focusNode: messageFocus,
                      controller: messageController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.send,
                      style: TextStyle(
                        fontFamily: 'BackToSchool',
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all( 16),
                        prefixIcon: Image.asset('assets/images/pencil.png'),
                        hintText: 'Enter your message',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (val) {
                        if (val != '') {
                          BlocProvider.of<ChallengeBloc>(Global.instance.homeContext).add(
                              SendChallengeMessageEvent(
                                type: isPrivate ? 'private': 'public',
                                message: messageController.text,
                                userId: Global.instance.userId,
                                userName: Global.instance.userModel.name,
                                userImage: Global.instance.userModel.image,
                              )
                          );
                        }
                        messageController.clear();
                      },
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      if (messageController.text != '') {
                        BlocProvider.of<ChallengeBloc>(Global.instance.homeContext).add(
                            SendChallengeMessageEvent(
                              type: isPrivate ? 'private': 'public',
                              message: messageController.text,
                              userId: Global.instance.userId,
                              userName: Global.instance.userModel.name,
                              userImage: Global.instance.userModel.image,
                            )
                        );
                      }
                      messageController.clear();
                    },
                    padding: EdgeInsets.zero,
                    minWidth: 0,
                    height: 50,
                    shape: CircleBorder(),
                    child: Image.asset('assets/images/btn_send.png', width: 50, height: 50,),
                  ),
                ],
              ),
            ),
        ): Container(),
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
        ): Container(),
      ],
    );
  }

  Widget _challengeListWidget(ChallengeState state) {
    if (currentChallengeType == 0 && currentIndex == 0) {
      return Container(
        child: ListView.separated(
          shrinkWrap: false,
          itemBuilder: (context, index) {
            ChallengeModel challengeModel = state.liveChallengeList[index];
            return LiveChallengeOnGoingCell(
              challengeModel: challengeModel,
              onTap: () {
                BlocProvider.of<ChallengeBloc>(Global.instance.homeContext).add(ShowChatEvent(selectedChallenge: challengeModel));
                setState(() {
                  isPrivate = false;
                });
              },
              tapUser: (user) {
                print(user);
                Navigator.push(
                  context,
                  PageTransition(
                    child: OtherUserProfileScreen(
                      screenBloc: widget.screenBloc,
                      userModel: user,
                    ),
                    type: PageTransitionType.fade,
                  ),
                );
              },
            );
          },
          separatorBuilder: (context, index) {
            return Divider(color: Colors.transparent, height: 4,);
          },
          itemCount: state.liveChallengeList.length,
        ),
      );
    } else if (currentChallengeType == 0 && currentIndex == 1) {
      return Container(
        child: ListView.separated(
          shrinkWrap: false,
          itemBuilder: (context, index) {
            return LiveChallengeFinishedCell(
              challengeModel: state.liveChallengeResultList[index],
              onTap: () {
              },
              tapUser: (user) {
                Navigator.push(
                  context,
                  PageTransition(
                    child: OtherUserProfileScreen(
                      screenBloc: widget.screenBloc,
                      userModel: user,
                    ),
                    type: PageTransitionType.fade,
                  ),
                );
              },
            );
          },
          separatorBuilder: (context, index) {
            return Divider(color: Colors.transparent, height: 4,);
          },
          itemCount: state.liveChallengeResultList.length,
        ),
      );
    } else if (currentChallengeType == 1 && currentIndex == 0) {
      return Container(
        child: ListView.separated(
          shrinkWrap: false,
          itemBuilder: (context, index) {
            ChallengeModel challengeModel = state.scheduleChallengeList[index];
            return ScheduleChallengeScheduledCell(
              challengeModel: challengeModel,
              onTap: () async {
                if (challengeModel.sender == Global.instance.userId || challengeModel.receiver == Global.instance.userId) {
                  int remain = (challengeModel.challengeTime.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch) ~/ 1000;
                  if (remain < 60 && remain > 0) {
                    String uid = state.selectedChallenge.sender;
                    if (state.selectedChallenge.sender == Global.instance.userId) {
                      uid = state.selectedChallenge.receiver;
                    }
                    UserModel user = await FirestoreService().getUserWithId(uid);
                    Navigator.push(
                      context,
                      PageTransition(
                        child: GameInScreen(
                          userModel: user,
                          challengeModel: state.selectedChallenge,
                        ),
                        type: PageTransitionType.fade,
                        duration: Duration(milliseconds: 300),
                      ),
                    );
                  } else {
                    BlocProvider.of<ChallengeBloc>(Global.instance.homeContext).add(ShowChatEvent(selectedChallenge: challengeModel));
                    setState(() {
                      isPrivate = false;
                    });
                  }
                } else {
                  BlocProvider.of<ChallengeBloc>(Global.instance.homeContext).add(ShowChatEvent(selectedChallenge: challengeModel));
                  setState(() {
                    isPrivate = false;
                  });
                }
              },
              tapUser: (user) {
                Navigator.push(
                  context,
                  PageTransition(
                    child: OtherUserProfileScreen(
                      screenBloc: widget.screenBloc,
                      userModel: user,
                    ),
                    type: PageTransitionType.fade,
                  ),
                );
              },
            );
          },
          separatorBuilder: (context, index) {
            return Divider(color: Colors.transparent, height: 4,);
          },
          itemCount: state.scheduleChallengeList.length,
        ),
      );
    } else if (currentChallengeType == 1 && currentIndex == 1) {
      return Container(
        child: ListView.separated(
          shrinkWrap: false,
          itemBuilder: (context, index) {
            ChallengeModel challengeModel = state.scheduleChallengeResultList[index];
              return LiveChallengeFinishedCell(
                challengeModel: challengeModel,
                onTap: () {
                },
                tapUser: (user) {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: OtherUserProfileScreen(
                        screenBloc: widget.screenBloc,
                        userModel: user,
                      ),
                      type: PageTransitionType.fade,
                    ),
                  );
                },
              );
          },
          separatorBuilder: (context, index) {
            return Divider(color: Colors.transparent, height: 4,);
          },
          itemCount: state.scheduleChallengeResultList.length,
        ),
      );
    } else {
      return Center(
        child: Align(
          alignment: Alignment.center,
          child: AppLabel(
            title: 'There are currently no games.',
            maxLine: 2,
            alignment: TextAlign.center,
          ),
        ),
      );
    }
  }

  Shader getTextGradient(RenderBox renderBox) {
    if (renderBox == null) return null;
    return LinearGradient(
      colors: <Color>[
        Color(0xffffbb28),
        Color(0xFFe67827),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).createShader(Rect.fromLTWH(
        renderBox.localToGlobal(Offset.zero).dx,
        renderBox.localToGlobal(Offset.zero).dy,
        renderBox.size.width,
        renderBox.size.height));
  }

  Widget _showChatView(ChallengeState state) {
    return Container(
      height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
      child: Column(
        children: [
          currentChallengeType == 0 ? LiveChallengeOnGoingCell(
            challengeModel: state.selectedChallenge,
            onTap: () {
              if (state.selectedChallenge.sender == Global.instance.userId || state.selectedChallenge.receiver == Global.instance.userId) {

              } else {
                BlocProvider.of<ChallengeBloc>(Global.instance.homeContext).add(ShowChatEvent(selectedChallenge: state.selectedChallenge));
                setState(() {
                  isPrivate = false;
                });
              }
            },
            tapUser: (user) {
              Navigator.push(
                context,
                PageTransition(
                  child: OtherUserProfileScreen(
                    screenBloc: widget.screenBloc,
                    userModel: user,
                  ),
                  type: PageTransitionType.fade,
                ),
              );
            },
          ) : ScheduleChallengeScheduledCell(
            challengeModel: state.selectedChallenge,
            onTap: () async {
              if (state.selectedChallenge.sender == Global.instance.userId || state.selectedChallenge.receiver == Global.instance.userId) {
                int remain = (state.selectedChallenge.challengeTime.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch) ~/ 1000;
                if (remain < 60 && remain > 0) {
                  String uid = state.selectedChallenge.sender;
                  if (state.selectedChallenge.sender == Global.instance.userId) {
                    uid = state.selectedChallenge.receiver;
                  }
                  UserModel user = await FirestoreService().getUserWithId(uid);
                  Navigator.push(
                    context,
                    PageTransition(
                      child: GameInScreen(
                        userModel: user,
                        challengeModel: state.selectedChallenge,
                      ),
                      type: PageTransitionType.fade,
                      duration: Duration(milliseconds: 300),
                    ),
                  );
                }
              }
            },
            tapUser: (user) {
              Navigator.push(
                context,
                PageTransition(
                  child: OtherUserProfileScreen(
                    screenBloc: widget.screenBloc,
                    userModel: user,
                  ),
                  type: PageTransitionType.fade,
                ),
              );
            },
          ),
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: Image.asset('assets/images/bg_challenge_chat.png',).image,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  height: 100,
                  left: 50,
                  right: 50,
                  top: 0,
                  child: Container(
                    alignment: Alignment.center,
                    child: state.selectedChallenge.sender == Global.instance.userId || state.selectedChallenge.receiver == Global.instance.userId ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Opacity(
                            opacity: isPrivate ? 0.5 : 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isPrivate = false;
                                });
                              },
                              child: Container(
                                height: 64,
                                width: 64,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: isPrivate ? Colors.transparent : Colors.white24,
                                ),
                                child: Image.asset('assets/images/public_message.png',),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8,),
                        Expanded(
                          flex: 1,
                          child: Opacity(
                            opacity: isPrivate ? 1 : 0.5,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isPrivate = true;
                                });
                              },
                              child: Container(
                                height: 64,
                                width: 64,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: isPrivate ? Colors.white24 : Colors.transparent,
                                ),
                                child: Image.asset('assets/images/private_message.png',),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ) : Container(
                      height: 64,
                      width: 64,
                      child: Image.asset('assets/images/public_message.png',),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    child: MaterialButton(
                      onPressed: () {
                        BlocProvider.of<ChallengeBloc>(Global.instance.homeContext).add(HideChatEvent());
                      },
                      child: Image.asset('assets/images/close_button.png'),
                    ),
                  ),
                ),
                Positioned(
                  top: 100,
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      MessageModel messageModel = isPrivate ? state.privateMessages[index] : state.publicMessages[index];
                      return MessageCell(
                        messageModel: messageModel,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Container(height: 8,);
                    },
                    itemCount: isPrivate ? state.privateMessages.length: state.publicMessages.length,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
