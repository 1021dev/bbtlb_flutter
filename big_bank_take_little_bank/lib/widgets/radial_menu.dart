import 'package:flutter/material.dart';
import 'dart:math';

class RadialMenu extends StatefulWidget {
  final Function onTapMenu;
  RadialMenu({this.onTapMenu});
  createState() => _RadialMenuState();
}

class _RadialMenuState extends State<RadialMenu> with SingleTickerProviderStateMixin {

  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    double iconSize = MediaQuery.of(context).size.width / 6.5;
    return RadialAnimation(
      controller: controller,
      width: MediaQuery
          .of(context)
          .size
          .width / 2 - iconSize,
      onTapMenu: widget.onTapMenu,
      iconSize: iconSize,
    );
  }

}

// The Animation
class RadialAnimation extends StatelessWidget {
  RadialAnimation({ Key key, this.controller, double width, this.onTapMenu, this.iconSize}) :

        scale = Tween<double>(
          begin: 1.5,
          end: 0.0,
        ).animate(
          CurvedAnimation(
              parent: controller,
              curve: Curves.fastOutSlowIn,
          ),
        ),
        translation = Tween<double>(
          begin: 0.0,
          end: width ?? 150,
        ).animate(
          CurvedAnimation(
              parent: controller,
              curve: Curves.fastOutSlowIn,
          ),
        ),
        rotation = Tween<double>(
          begin: 0.0,
          end: 360.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.3, 0.9,
              curve: Curves.decelerate,
            ),
          ),
        ),

        super(key: key);

  final AnimationController controller;
  final Animation<double> scale;
  final Animation<double> translation;
  final Animation<double> rotation;
  final Function onTapMenu;
  final double iconSize;

  build(context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, builder) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              _buildButton(pi * 1.05, Image.asset('assets/images/menu_state.png', width: iconSize, height: iconSize,), 1),
              _buildButton(pi * 1.2, Image.asset('assets/images/menu_friends.png', width: iconSize, height: iconSize,), 2),
              _buildButton(pi * 1.35, Image.asset('assets/images/menu_challenge.png', width: iconSize, height: iconSize,), 3),
              _buildButton(pi * 1.5, Image.asset('assets/images/menu_home.png', width: iconSize, height: iconSize,), 4),
              _buildButton(pi * 1.65, Image.asset('assets/images/menu_chat.png', width: iconSize, height: iconSize,), 5),
              _buildButton(pi * 1.8, Image.asset('assets/images/menu_inbox.png', width: iconSize, height: iconSize,), 6),
              _buildButton(pi * 1.95, Image.asset('assets/images/menu_settings.png', width: iconSize, height: iconSize,), 7),
              Transform.scale(
                scale: 1.5 - scale.value, // subtract the beginning value to run the opposite animation
                child: InkWell(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: iconSize * 0.3),
                    child: Image.asset('assets/images/home_menu_iconn.png', width: iconSize * 1.2, height: iconSize * 1.2,),
                  ),
                  onTap: _close,
                ),
              ),
              Transform.scale(
                scale: scale.value,
                child: InkWell(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: iconSize * 0.3),
                    child: Image.asset('assets/images/home_menu_iconn.png', width: iconSize * 1.2, height: iconSize * 1.2,),
                  ),
                  onTap: _open,
                ),
              ),
            ],
          );
        });
  }

  _buildButton(double angle, Widget icon, int index) {
    final double rad = angle;
    return Transform(
        transform: Matrix4.identity()..translate(
            (translation.value) * cos(rad),
            (translation.value) * sin(rad)
        ),
        child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(iconSize / 2),
          ),
          minWidth: 0,
          padding: EdgeInsets.zero,
          child: Padding(
            padding: EdgeInsets.only(bottom: iconSize * 0.3),
            child: icon,
          ),
          onPressed: () {
            onTapMenu(index);
            _close();
          }
        ),
    );
  }

  _open() {
    controller.forward();
  }

  _close() {
    controller.reverse();
  }
}
