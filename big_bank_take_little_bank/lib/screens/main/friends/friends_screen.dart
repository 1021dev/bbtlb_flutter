import 'package:auto_size_text/auto_size_text.dart';
import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/utils/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FriendsScreen extends StatefulWidget {
  final MainScreenBloc screenBloc;
  FriendsScreen({Key key, this.screenBloc}) : super(key: key);

  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {

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

  Widget _body(MainScreenLoadState state) {
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
                child: Image.asset('assets/images/ic_friends_header.png',),
              ),
              Positioned(
                top: 124,
                left: 24,
                right: 24,
                bottom: 24,
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return Container();
                  },
                  separatorBuilder: (context, index) {
                    return Container();
                  },
                  itemCount: 0,
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
