import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/utils/app_color.dart';
import 'package:big_bank_take_little_bank/widgets/app_text.dart';
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
  final FriendsBloc friendsBloc = FriendsBloc(FriendsInitState());

  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    friendsBloc.add(LoadFriendsList());
    super.initState();
  }

  @override
  void dispose() {
    friendsBloc.close();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: friendsBloc,
      listener: (BuildContext context, FriendsState state) async {
        if (state is FriendsSuccess) {
        } else if (state is FriendsFailure) {
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
      child: BlocBuilder<FriendsBloc, FriendsState>(
        cubit: friendsBloc,
        builder: (BuildContext context, FriendsState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _body(FriendsState state) {
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
              (state is FriendsListLoadState) ? Positioned(
                top: 124,
                left: 24,
                right: 24,
                bottom: 24,
                child: state.friendsList.length > 0 ? _friendsListWidget(state): Center(
                  child: AppLabel(
                    title: 'Currently you don\'t have any friends',
                  ),
                ),
              ): Container(),
            ],
          ),
        ),
        // Positioned(
        //   height: MediaQuery.of(context).size.height,
        //   width: MediaQuery.of(context).size.width,
        //   child: Container(
        //     color: Colors.black12,
        //     child: SpinKitDoubleBounce(
        //       color: Colors.red,
        //       size: 50.0,
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _friendsListWidget(FriendsListLoadState state) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            padding: EdgeInsets.only(left: 16,),
            height: 50,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg_search_field.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Transform.rotate(
              angle: -pi / 100.0,
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search friends'
                      ),
                      style: TextStyle(
                        fontFamily: 'BackToSchool',
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: (){

                    },
                    minWidth: 0,
                    shape: CircleBorder(),
                    height: 44,
                    child: Image.asset('assets/images/searchicon.png',
                      width: 32, height: 32,),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container();
              },
              separatorBuilder: (context, index) {
                return Container();
              },
              itemCount: 0,
            ),
          )
        ],
      ),
    );
  }

}
