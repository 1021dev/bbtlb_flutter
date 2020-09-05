import 'dart:math';

import 'package:align_positioned/align_positioned.dart';
import 'package:big_bank_take_little_bank/utils/app_constant.dart';
import 'package:big_bank_take_little_bank/widgets/animated_bubble.dart';
import 'package:big_bank_take_little_bank/widgets/make_circle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GameWinScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _GGameWinScreenState();
  }
}

class _GGameWinScreenState extends State<GameWinScreen> with TickerProviderStateMixin {

// a key to set on our Text widget, so we can measure later
  GlobalKey myTextKey = GlobalKey();
// a RenderBox object to use in state
  RenderBox myTextRenderBox;
  Animation<double> bubbleAnimation;
  AnimationController bubbleController;
  final bubbleWidgets = List<Widget>();
  bool areBubblesAdded = false;
  AlignmentTween alignmentTop = AlignmentTween(begin: Alignment.topRight,end: Alignment.topLeft);
  AlignmentTween alignmentBottom = AlignmentTween(begin: Alignment.bottomRight,end: Alignment.bottomLeft);
  CurvedAnimation curvedAnimation;

  @override
  void initState() {
    bubbleController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    curvedAnimation =
        CurvedAnimation(parent: bubbleController, curve: Curves.easeOut);
    bubbleAnimation = CurvedAnimation(parent: bubbleController, curve: Curves.easeIn)..addListener((){
    })
      ..addStatusListener((status){

        if(status == AnimationStatus.completed){
          setState(() {
            // addBubbles(animation: bubbleAnimation,topPos: -1.001,bubbles:2);
            // bubbleController.reverse();
          });
        }
        if(status == AnimationStatus.dismissed){
          setState(() {
            // addBubbles(animation: bubbleAnimation,topPos: -1.001,bubbles:2);
            // bubbleController.forward();
          });
        }
      });


    bubbleController.forward();
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
    bubbleController.dispose();
    super.dispose();
  }

  void addBubbles({animation, topPos = 0, leftPos = 0, bubbles = 50}) {

    for(var i = 0; i < bubbles; i++) {

      var range = Random();
      var minSize = 20 + range.nextInt(50).toDouble();
      var maxSize = 50 + range.nextInt(100).toDouble();
      var left = leftPos == 0 ? range.nextInt(MediaQuery.of(context).size.width.toInt() - 50).toDouble() : leftPos;
      var top = topPos == 0 ? - range.nextInt(MediaQuery.of(context).size.height.toInt()).toDouble() : topPos;

      int index = Random().nextInt(10);
      Image image = AppConstant.images[index];
      var bubble = new Positioned(
        left: left,
        top: top,
        child: AnimatedBubble(
          animation: animation,
          startSize: maxSize,
          endSize: maxSize,
          image: image,
          size: minSize,
        ),
      );

      setState(() {
        areBubblesAdded = true;
        bubbleWidgets.add(bubble);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if(!areBubblesAdded){
      addBubbles(animation: bubbleAnimation);
    }
    return AnimatedBuilder(
      animation: bubbleAnimation,
      builder: (BuildContext context, Widget child) {
        Animation<double> _translationAnim = Tween(begin: -MediaQuery.of(context).size.width * 0.5, end: 0.0)
            .animate(curvedAnimation)..addListener(() {setState(() {

        });});

        Animation<double> _scaleAnim = Tween(begin: 0.0, end: 1.0).animate(curvedAnimation)..addListener(() {setState(() {

        });});

        Animation<double> _rotateAnimation = Tween(begin: 0.0, end: 4.0 * pi).animate(curvedAnimation)..addListener(() {setState(() {

        });});
        return Scaffold(
          body: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.height,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xffce5281),
                      Color(0xff6e1c83),
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
                          color: Color(0xff74234d),
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
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Stack(
                  children: <Widget>[]+bubbleWidgets,
                ),
              ),
              AlignPositioned(
                alignment: Alignment.center,
                dy: MediaQuery.of(context).size.height * 0.1, // Move 4 pixels to the right.
                child: Transform(
                  transform: Matrix4.identity()..translate(_translationAnim.value, 0, 0),
                  alignment: Alignment.center,
                  child: Image.asset('assets/images/congrate.png', width: MediaQuery.of(context).size.width * 0.9,),
                ),
              ),
              AlignPositioned(
                alignment: Alignment.center,
                dy: - MediaQuery.of(context).size.height * 0.1, // Move 4 pixels to the right.
                child: Transform(
                  transform: Matrix4.identity()..scale(_scaleAnim.value, _scaleAnim.value)..rotateZ(_rotateAnimation.value),
                  alignment: Alignment.center,
                  child: Image.asset('assets/images/pig_win_1.png', width: 200, height: 200,),
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
              )
            ],
          ),
        );
      },
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

