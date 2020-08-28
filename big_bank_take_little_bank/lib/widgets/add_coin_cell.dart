import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'animated_button.dart';
import 'app_button.dart';
import 'app_text.dart';

class AddCoinCell extends StatelessWidget {
  final Function onTap;
  final String type;

  AddCoinCell({this.onTap, this.type});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.7,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 8,
              right: 8,
              top: 0,
              bottom: 24,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF5c9c85),
                  Color(0xFF35777e),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                  spreadRadius: 1.0,
                  offset: Offset(
                    4.0,
                    4.0,
                  ),
                ),
              ],
            ),
            padding: EdgeInsets.only(
              left: 12,
              top: 14,
              bottom: 24,
              right: 12,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xaa000000),
                  ),
                  BoxShadow(
                    color: Color(0xFF0e3d48),
                    spreadRadius: -3.0,
                    blurRadius: 12.0,
                  ),
                ],
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Flexible(
                    flex: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Flexible(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width * 0.25,
            padding: EdgeInsets.only(bottom: 12, top: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                  flex: 2,
                  child: getIcon(),
                ),
                Flexible(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppLabel(
                        title: 'Get',
                        shadow: true,
                        fontSize: 16,
                      ),
                      AppGradientLabel(
                        title: getAmount(),
                        shadow: true,
                        fontSize: 24,
                      ),
                      AppButtonLabel(
                        title: 'POINTS',
                        shadow: true,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: AnimatedButton(
                    onTap: onTap,
                    content: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: getBackgroundColor('yellow'),
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: getStrokeColor('yellow'),
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x80000000),
                              offset: Offset(3,5),
                            ),
                            BoxShadow(
                              color: getStrokeColor('yellow'),
                              spreadRadius: 3,
                              blurRadius: 10,
                            ),
                            BoxShadow(
                              color: Color(0xAA000000),
                              spreadRadius: -5,
                              blurRadius: 2,
                              offset: Offset(7,10),
                            ),
                          ]
                      ),
                      padding: EdgeInsets.all(4),
                      child: Stack(
                        children: [
                          Container(
                            height: 20,
                            decoration: BoxDecoration(
                              color: Color(0x44ffffff),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          Center(
                            child: Text(
                              getPrice(),
                              style: TextStyle(
                                fontSize: 28,
                                shadows: [
                                  Shadow(
                                    color: Colors.black45,
                                    offset: Offset(4.0, 4.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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

  String getAmount() {
    switch(type) {
      case '1000':
        return '1,000';
      case '4000':
        return '4,000';
      case '10000':
        return '10,000';
      case '25000':
        return '25,000';
      case '150000':
        return '150,000';
      case 'ads':
        return 'ADS';
      default:
        return 'ADS';
    }
  }

  String getPrice() {
    switch(type) {
      case '1000':
        return '\$1.99';
      case '4000':
        return '\$4.99';
      case '10000':
        return '\$9.99';
      case '25000':
        return '\$19.99';
      case '150000':
        return '\$99.99';
      case 'ads':
        return 'NOW';
      default:
        return 'NOW';
    }
  }

  Image getIcon() {
    switch(type) {
      case '1000':
        return Image.asset('assets/images/ic_1000.png');
      case '4000':
        return Image.asset('assets/images/ic_4000.png');
      case '10000':
        return Image.asset('assets/images/ic_10000.png');
      case '25000':
        return Image.asset('assets/images/ic_25000.png');
      case '150000':
        return Image.asset('assets/images/ic_150000.png');
      case 'ads':
        return Image.asset('assets/images/ic_ads.png');
      default:
        return Image.asset('assets/images/ic_ads.png');
    }
  }
}