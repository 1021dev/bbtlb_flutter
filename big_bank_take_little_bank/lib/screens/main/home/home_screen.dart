import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/utils/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  final MainScreenBloc screenBloc;
  HomeScreen({Key key, this.screenBloc}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

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
          return SafeArea(
            child: _body(state),
          );
        },
      ),
    );
  }

  Widget _body(MainScreenState state) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(8),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {

                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 4,
                        child: Image.asset(
                          'assets/images/btn_nearby.png',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                    ),
                    InkWell(
                      onTap: () {

                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 4,
                        child: Image.asset(
                          'assets/images/btn_live.png',
                          height: MediaQuery.of(context).size.width,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {

                },
                child: Container(
                  height: 100,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/images/bg_points.png',
                        width: MediaQuery.of(context).size.width / 3,
                      ),
                      Column(
                        children: [
                          Image.asset('assets/images/level_1_user_profile.png', width: 36,),
                          SizedBox(height: 4,),
                          Text(
                            state.currentUser != null ? '${state.currentUser.points}': '0',
                            style: TextStyle(
                              fontFamily: 'BackToSchool',
                              fontSize: 16,
                              color: Color(0xffF39B27),
                            ),
                          ),
                          Text(
                            state.currentUser != null ? 'Level ${state.currentUser.level}': 'Level 1',
                            style: TextStyle(
                              fontFamily: 'BackToSchool',
                              fontSize: 13,
                            ),
                          ),
                        ],
                      )
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
