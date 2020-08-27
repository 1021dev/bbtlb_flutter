import 'package:big_bank_take_little_bank/blocs/ads_rewards/ads_rewards.dart';
import 'package:big_bank_take_little_bank/widgets/add_coin_cell.dart';
import 'package:big_bank_take_little_bank/widgets/app_button.dart';
import 'package:big_bank_take_little_bank/widgets/app_text.dart';
import 'package:big_bank_take_little_bank/widgets/title_background_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPointsScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
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
    return Scaffold(
      body: _body(),
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
          bottom: 0,
          child: Image.asset('assets/images/bg_home.png', fit: BoxFit.fill,),
        ),
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: Image.asset('assets/images/bg_top.png',),
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
                top: 100,
                left: 16,
                right: 16,
                bottom: 0,
                child: SingleChildScrollView(
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
