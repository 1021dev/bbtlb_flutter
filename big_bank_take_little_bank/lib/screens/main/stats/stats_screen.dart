import 'package:auto_size_text/auto_size_text.dart';
import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/utils/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class StatsScreen extends StatefulWidget {
  final MainScreenBloc screenBloc;
  StatsScreen({Key key, this.screenBloc}) : super(key: key);

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {

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
    return BlocListener(
      cubit: widget.screenBloc,
      listener: (BuildContext context, MainScreenState state) async {
        if (state is LoginScreenSuccess) {
        } else if (state is MainScreenFailure) {
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
      child: BlocBuilder<MainScreenBloc, MainScreenState>(
        cubit: widget.screenBloc,
        builder: (BuildContext context, MainScreenState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _body(MainScreenState state) {
    double itemWidth = ((MediaQuery.of(context).size.width - 56) / 2);
    double itemHeight = itemWidth / 526 * 624;
    return Stack(
      fit: StackFit.expand,
      children: [
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
                top: 24,
                width: MediaQuery.of(context).size.width * 0.6,
                child: Image.asset('assets/images/ic_stats_head.png',),
              ),
              Positioned(
                top: 100,
                left: 0,
                right: 0,
                bottom: 0,
                child: Image.asset('assets/images/bg_stats.png', fit: BoxFit.fill, ),
              ),
              Positioned(
                top: 124,
                left: 24,
                right: 24,
                bottom: 24,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: AspectRatio(
                              aspectRatio: 526 / 624,
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Image.asset(
                                      'assets/images/bg_stats_item.png',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Positioned(
                                    top: 12,
                                    left: 24,
                                    right: 24,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: AspectRatio(
                                            aspectRatio: 1,
                                            child: Image.asset(
                                              'assets/images/ic_challenge_request_pig.png',
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8,),
                                        Flexible(
                                          child: AspectRatio(
                                            aspectRatio: 1,
                                            child: Image.asset(
                                              'assets/images/ic_challenge_requested_stats.png',
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    left: 28,
                                    right: 28,
                                    child: Text(
                                      '0',
                                      style: TextStyle(
                                        color: Color(0xffF49E28),
                                        fontSize: 32,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 24,
                                    right: 24,
                                    bottom: 24,
                                    child: AutoSizeText(
                                      'CHALLENGES REQUESTED',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 8,),
                          Flexible(
                            child: AspectRatio(
                              aspectRatio: 526 / 624,
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Image.asset(
                                      'assets/images/bg_stats_item.png',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Positioned(
                                    top: 12,
                                    left: 24,
                                    right: 24,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: AspectRatio(
                                            aspectRatio: 1,
                                            child: Image.asset(
                                              'assets/images/level_1_challenger.png',
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8,),
                                        Flexible(
                                          child: AspectRatio(
                                            aspectRatio: 1,
                                            child: Image.asset(
                                              'assets/images/ic_challenge_accepted_stats.png',
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    left: 28,
                                    right: 28,
                                    child: Text(
                                      '0',
                                      style: TextStyle(
                                        color: Color(0xffF49E28),
                                        fontSize: 32,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 24,
                                    right: 24,
                                    bottom: 24,
                                    child: AutoSizeText(
                                      'CHALLENGES ACCEPTED',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: AspectRatio(
                              aspectRatio: 526 / 624,
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Image.asset(
                                      'assets/images/bg_stats_item.png',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Positioned(
                                    top: 12,
                                    left: 24,
                                    right: 24,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: AspectRatio(
                                            aspectRatio: 1,
                                            child: Image.asset(
                                              'assets/images/ic_challenge_decline_pig.png',
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8,),
                                        Flexible(
                                          child: AspectRatio(
                                            aspectRatio: 1,
                                            child: Image.asset(
                                              'assets/images/ic_challenge_declined_stats.png',
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    left: 28,
                                    right: 28,
                                    child: Text(
                                      '0',
                                      style: TextStyle(
                                        color: Color(0xffF49E28),
                                        fontSize: 32,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 24,
                                    right: 24,
                                    bottom: 24,
                                    child: AutoSizeText(
                                      'CHALLENGES DECLINED',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 8,),
                          Flexible(
                            child: AspectRatio(
                              aspectRatio: 526 / 624,
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Image.asset(
                                      'assets/images/bg_stats_item.png',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Positioned(
                                    top: 12,
                                    left: 24,
                                    right: 24,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Transform.scale(
                                            scale: 1.5,
                                            child: AspectRatio(
                                              aspectRatio: 1.2,
                                              child: Image.asset(
                                                'assets/images/ic_challenge_achivement.png',
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8,),
                                        Flexible(
                                          child: AspectRatio(
                                            aspectRatio: 1,
                                            child: Image.asset(
                                              'assets/images/ic_challenge_requested_stats.png',
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    left: 28,
                                    right: 28,
                                    child: Text(
                                      '0',
                                      style: TextStyle(
                                        color: Color(0xffF49E28),
                                        fontSize: 32,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 24,
                                    right: 24,
                                    bottom: 24,
                                    child: AutoSizeText(
                                      'ACHIEVEMENTS\nAWARDED',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 2,
                            child: Container(
                              height: itemHeight,
                              width: itemWidth * 1.3,
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Image.asset(
                                      'assets/images/bg_stats_item.png',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Positioned(
                                    top: 12,
                                    right: 16,
                                    width: itemWidth * 0.4,
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: Image.asset(
                                        'assets/images/ic_scheduled_stats.png',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 28,
                                    right: 28,
                                    child: Text(
                                      '0',
                                      style: TextStyle(
                                        color: Color(0xffF49E28),
                                        fontSize: 32,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 24,
                                    right: 24,
                                    bottom: 24,
                                    child: AutoSizeText(
                                      'CHALLENGES SCHEDULED',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 3,
                            child: Container(
                              height: itemHeight,
                              width: itemWidth * 1.3,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Image.asset(
                                      'assets/images/bg_stats_item.png',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Positioned(
                                    top: itemHeight * 0.15,
                                    left: itemHeight * 0.18,
                                    right: itemHeight * 0.18,
                                    bottom: itemHeight * 0.4,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(16),
                                              color: Color(0xFF154551),
                                            ),
                                            padding: EdgeInsets.all(8),
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                  'assets/images/hammer_im.png',
                                                  width: 24,
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  '0',
                                                  style: TextStyle(
                                                    color: Color(0xffD741D8),
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    'LOSSES',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8,),
                                        Flexible(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(16),
                                              color: Color(0xFF154551),
                                            ),
                                            padding: EdgeInsets.all(8),
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                  'assets/images/hammer_im.png',
                                                  width: 24,
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  '0',
                                                  style: TextStyle(
                                                    color: Color(0xff84B55A),
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    'WINS',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    left: 24,
                                    right: 24,
                                    bottom: 24,
                                    child: AutoSizeText(
                                      'CHALLENGES\nRESULTS',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
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
              ),
            ],
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
        ): Container()
      ],
    );
  }

}
