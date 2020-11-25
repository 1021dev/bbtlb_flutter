import 'package:align_positioned/align_positioned.dart';
import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/models/challenge_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:big_bank_take_little_bank/screens/main/challenge/game_loss_screen_temp.dart';
import 'package:big_bank_take_little_bank/screens/main/challenge/game_tie_screen_temp.dart';
import 'package:big_bank_take_little_bank/screens/main/challenge/game_win_screen_temp.dart';
import 'package:big_bank_take_little_bank/widgets/app_text.dart';
import 'package:big_bank_take_little_bank/widgets/gradient_progress.dart';
import 'package:big_bank_take_little_bank/widgets/make_circle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';


class GameInScreen extends StatefulWidget {
  final ChallengeModel challengeModel;
  final UserModel userModel;
  final DateTime startTime;
  GameInScreen({this.challengeModel, this.userModel, this.startTime,});
  @override
  State<StatefulWidget> createState() {
    return _GameInScreenState();
  }
}

class _GameInScreenState extends State<GameInScreen> with TickerProviderStateMixin {
  AnimationController _animationController;

// a key to set on our Text widget, so we can measure later
  GlobalKey myTextKey = GlobalKey();
// a RenderBox object to use in state
  RenderBox myTextRenderBox;

  GameBloc gameBloc;

  @override
  void initState() {

    gameBloc = BlocProvider.of<GameBloc>(Global.instance.homeContext);
    int countDown = 10;
    if (widget.startTime != null) {
      DateTime challengeTime = widget.startTime;
      int duration = DateTime.now().difference(challengeTime).inSeconds;
      countDown = duration;
    } else {
      if (widget.challengeModel.type == 'live') {
        countDown = 120;
      } else if (widget.challengeModel.type == 'schedule') {
        countDown = 120;
      }
    }
    _animationController = new AnimationController(vsync: this, duration: Duration(seconds: countDown))..addListener(() {
      setState(() {});
    })..addStatusListener((status)async {
      if(status == AnimationStatus.completed){
        if (_animationController != null) {
          _animationController.dispose();
        }
        print('rest');
        BlocProvider.of<GameBloc>(Global.instance.homeContext).add(GameResultEvent(model: widget.challengeModel, userModel: widget.userModel));
      }
    });

    _animationController.forward();
    // _animationController.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) => _recordSize());
    super.initState();
  }

  void _recordSize() {
    // now we set the RenderBox and trigger a redraw
    setState(() {
      myTextRenderBox = myTextKey.currentContext.findRenderObject();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (_animationController != null) {
      _animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: gameBloc,
      listener: (BuildContext context, GameState state) async {
        if (state is GameResultState) {
          if (state.userModel.points == Global.instance.userModel.points) {
            Navigator.pushReplacement(
              context,
              PageTransition(
                child: GameTieTempScreen(),
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 300),
              ),
            );
          } else if (state.userModel.points > Global.instance.userModel.points) {
            Navigator.pushReplacement(
              context,
              PageTransition(
                child: GameLossTempScreen(),
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 300),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              PageTransition(
                child: GameWinTempScreen(
                  challengeModel: widget.challengeModel,
                  points: state.userModel.points,
                ),
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 300),
              ),
            );
          }
        }
      },
      child: BlocBuilder<GameBloc, GameState>(
        cubit: gameBloc,
        builder: (BuildContext context, GameState state) {
          int countDown = 10;
          if (widget.challengeModel.type == 'live') {
            countDown = 120;
          } else if (widget.challengeModel.type == 'schedule') {
            DateTime challengeTime = widget.challengeModel.challengeTime;
            int duration = challengeTime.difference(DateTime.now()).inSeconds;
            countDown = duration;
          }
          int time = countDown - (_animationController.value * countDown).toInt();
          if (time < 0) {
            time = 0;
          }
          return Scaffold(
            body: Stack(
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
                  child: Container(
                    width: MediaQuery.of(context).size.height,
                    height: MediaQuery.of(context).size.height,
                    decoration: MakeCircle(
                      strokeWidth: 44,
                      strokeCap: StrokeCap.square,
                    ),
                    child: AlignPositioned(
                      child: Container(
                        width: 272,
                        height: 272,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 32,
                            color: Color(0xff0e3d48),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: Offset(6, 6),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(4),
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                              ),
                              BoxShadow(
                                color: Color(0xff0e3d48),
                                spreadRadius: -8.0,
                                blurRadius: 12.0,
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(12),
                          child: Container(
                            height: 140,
                            width: 176,
                            margin: EdgeInsets.only(bottom: 48, left: 12, right: 12),
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.all(Radius.elliptical(176, 140)),
                              color: Color.fromRGBO(255, 255, 255, 0.07),
                            ),
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                      dy: - MediaQuery.of(context).size.height * 0.1, // Move 4 pixels to the right.
                    ),
                  ),
                ),
                AlignPositioned(
                  alignment: Alignment.center,
                  dy: - MediaQuery.of(context).size.height * 0.1, // Move 4 pixels to the right.
                  child: GradientCircularProgressIndicator(
                    gradientColors: [
                      Color(0xffff5554),
                      Color(0xffffbb28),
                      Color(0xffff5554),
                    ],
                    radius: 136,
                    strokeWidth: 32.0,
                    strokeRound: true,
                    backgroundColor: Color(0xff0e3d48),
                    value: new Tween(begin: 0.0, end: 1.0)
                        .animate(CurvedAnimation(
                        parent: _animationController, curve: Curves.linear),
                    ).value,
                  ),
                ),
                AlignPositioned(
                  alignment: Alignment.center,
                  dy: - MediaQuery.of(context).size.height * 0.06, // Move 4 pixels to the right.
                  child: Text(
                    '$time',
                    key: myTextKey,
                    style: new TextStyle(
                      fontSize: 180.0,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()..shader = getTextGradient(myTextRenderBox),
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(5.0, 5.0),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.1,
                  left: 0,
                  right: 0,
                  bottom: MediaQuery.of(context).size.height * 0.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          AppButtonLabel(
                            title: 'YOUR',
                            fontSize: 32,
                          ),
                          AppButtonLabel(
                            title: 'GAME BEGINS IN',
                            fontSize: 32,
                            shadow: true,
                          ),
                        ],
                      ),
                      AppButtonLabel(
                        title: 'SECONDS',
                        fontSize: 45,
                        shadow: true,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 16,
                  top: 20,
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    minWidth: 0,
                    padding: EdgeInsets.zero,
                    child: Image.asset('assets/images/ic_close_outline.png', width: 36, height: 36,),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Shader getTextGradient(RenderBox renderBox) {
    if (renderBox == null) return null;
    return LinearGradient(
      colors: <Color>[
        Color(0xffffbb28),
        Color(0xffff5554),
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

