import 'package:big_bank_take_little_bank/widgets/add_coin_cell.dart';
import 'package:big_bank_take_little_bank/widgets/title_background_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'ads_points_screen.dart';

class AddPointsScreen extends StatefulWidget {
  final BuildContext homeContext;

  AddPointsScreen({this.homeContext});

  @override
  State<AddPointsScreen> createState() {
    return _AddPointsScreenState();
  }
}

class _AddPointsScreenState extends State<AddPointsScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg_home.png'),
            fit: BoxFit.fill,
          ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: _body(),
      ),
    );
  }

  Widget _body() {
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
                top: 8,
                width: MediaQuery.of(context).size.width * 0.4,
                child: TitleBackgroundWidget(
                  title: 'ADD COINS',
                  height: 64,
                ),
              ),
              Positioned(
                top: 72,
                left: 16,
                right: 16,
                bottom: 0,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: AddCoinCell(
                              onTap: () {

                              },
                              type: '1000',
                            ),
                          ),
                          Flexible(
                            child: AddCoinCell(
                              onTap: () {

                              },
                              type: '4000',
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: AddCoinCell(
                              onTap: () {

                              },
                              type: '10000',
                            ),
                          ),
                          Flexible(
                            child: AddCoinCell(
                              onTap: () {

                              },
                              type: '25000',
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: AddCoinCell(
                              onTap: () {

                              },
                              type: '150000',
                            ),
                          ),
                          Flexible(
                            child: AddCoinCell(
                              onTap: () {
                                Navigator.push(context, PageTransition(
                                  child: AdsPointsScreen(
                                    homeContext: widget.homeContext,
                                  ),
                                  type: PageTransitionType.fade,
                                  duration: Duration(microseconds: 300),
                                ),
                                );
                              },
                              type: 'ads',
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
      ],
    );
  }
}
