import 'package:align_positioned/align_positioned.dart';
import 'package:big_bank_take_little_bank/widgets/app_text.dart';
import 'package:big_bank_take_little_bank/widgets/gradient_progress.dart';
import 'package:big_bank_take_little_bank/widgets/make_circle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GameTieScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _GameTieScreenState();
  }
}

class _GameTieScreenState extends State<GameTieScreen> with TickerProviderStateMixin {
  AnimationController _animationController;

// a key to set on our Text widget, so we can measure later
  GlobalKey myTextKey = GlobalKey();
// a RenderBox object to use in state
  RenderBox myTextRenderBox;

  @override
  void initState() {
    _animationController =
    new AnimationController(vsync: this, duration: Duration(seconds: 10));
    _animationController.addListener(() => setState(() {}));
    _animationController.repeat();
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
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
              '${(_animationController.value * 10).toInt() + 1}',
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
        ],
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

