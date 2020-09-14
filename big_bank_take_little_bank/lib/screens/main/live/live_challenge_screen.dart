
import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:big_bank_take_little_bank/screens/main/live/schedule_challenge_request_cell.dart';
import 'package:big_bank_take_little_bank/screens/main/live/schedule_challenge_scheduled_cell.dart';
import 'package:big_bank_take_little_bank/widgets/app_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  NotificationScreenBloc notificationScreenBloc;
  SlidableController slidableController;
// a key to set on our Text widget, so we can measure later
  GlobalKey myTextKey = GlobalKey();
// a RenderBox object to use in state
  RenderBox myTextRenderBox;

  int currentChallengeType = 0;
  int currentIndex = 0;

  @override
  void initState() {
    slidableController = SlidableController(
      onSlideAnimationChanged: null,
      onSlideIsOpenChanged: null,
    );
    notificationScreenBloc = BlocProvider.of<NotificationScreenBloc>(Global.instance.homeContext);
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
      cubit: notificationScreenBloc,
      listener: (BuildContext context, NotificationScreenState state) async {
        if (state is NotificationScreenSuccess) {
        } else if (state is NotificationScreenFailure) {
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
      child: BlocBuilder<NotificationScreenBloc, NotificationScreenState>(
        cubit: notificationScreenBloc,
        builder: (BuildContext context, NotificationScreenState state) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_home.png"),
                fit: BoxFit.cover,
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

  void _recordSize() {
    // now we set the RenderBox and trigger a redraw
    setState(() {
      myTextRenderBox = myTextKey.currentContext.findRenderObject();
    });
  }

  Widget _body(NotificationScreenState state) {
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
                                    title: currentChallengeType == 0 ? 'ONGOING': 'REQUEST',
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
                                    title: currentChallengeType == 0 ? 'FINISHED': 'SCHEDULED',
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
                        child: state.notifications.length > 0 ? _challengeListWidget(state): Center(
                          child: Align(
                            alignment: Alignment.center,
                            child: AppLabel(
                              title: 'There are currently no games.',
                              maxLine: 2,
                              alignment: TextAlign.center,
                            ),
                          ),
                        ),
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

  Widget _challengeListWidget(NotificationScreenState state) {
    return Container(
      child: ListView.separated(
        shrinkWrap: false,
        itemBuilder: (context, index) {
          if (currentChallengeType == 0) {
            if (currentIndex == 0) {
              return LiveChallengeOnGoingCell(
                notificationModel: state.notifications[index],
                onTap: () {

                },
              );
            } else {
              return LiveChallengeFinishedCell(
                notificationModel: state.notifications[index],
                onTap: () {

                },
              );
            }
          } else {
            if (currentIndex == 0) {
              return ScheduleChallengeRequestCell(
                notificationModel: state.notifications[index],
                onTap: () {

                },
              );
            } else {
              return ScheduleChallengeScheduledCell(
                notificationModel: state.notifications[index],
                onTap: () {

                },
              );
            }
          }
        },
        separatorBuilder: (context, index) {
          return Divider(color: Colors.transparent, height: 4,);
        },
        itemCount: state.notifications.length,
      ),
    );
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

}
