import 'dart:typed_data';

import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/screens/splash/splash_screen.dart';
import 'package:big_bank_take_little_bank/widgets/title_background_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contact/contact.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';

class InviteFriendsScreen extends StatefulWidget {
  final ProfileScreenBloc screenBloc;
  InviteFriendsScreen({Key key, this.screenBloc}) : super(key: key);

  @override
  _InviteFriendsScreenState createState() => _InviteFriendsScreenState();
}

class _InviteFriendsScreenState extends State<InviteFriendsScreen>  with SingleTickerProviderStateMixin {

  bool isHelp = false;
  AnimationController controller;
  Animation<double> translation;
  Animation<double> scaleAnim;
  CurvedAnimation curvedAnimation;

  @override
  void initState() {
    super.initState();
    widget.screenBloc.add(GetContactsEvent());
    controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    curvedAnimation =
        CurvedAnimation(parent: controller, curve: Curves.bounceInOut);
    scaleAnim = Tween(begin: 0.0, end: 1.0).animate(controller)..addListener(() { setState(() {

    });});

  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: widget.screenBloc,
      listener: (BuildContext context, ProfileScreenState state) async {
        if (state is ProfileScreenSuccess) {
          widget.screenBloc.add(ProfileScreenInitEvent());
        } else if (state is ProfileScreenFailure) {
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
        } else if (state is ProfileScreenLogout) {
          Navigator.pushReplacement(context, PageTransition(
            child: SplashScreen(),
            type: PageTransitionType.leftToRightWithFade,
            duration: Duration(microseconds: 500),
          ));
        }
      },
      child: BlocBuilder<ProfileScreenBloc, ProfileScreenState>(
        cubit: widget.screenBloc,
        builder: (BuildContext context, ProfileScreenState state) {
          return Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg_home.png'),
                )
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: _body(state),
            ),
          );
        },
      ),
    );
  }

  Widget _body(ProfileScreenState state) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.topCenter,
      children: [
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: Image.asset('assets/images/bg_top_bar_trans.png',),
        ),
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          bottom: 0,
          child: SafeArea(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: 20,
                  height: 64,
                  width: 200,
                  child: TitleBackgroundWidget(
                    title: 'Invite Friends',
                  ),
                ),
                Positioned(
                  top: 84,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: double.infinity,
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            itemBuilder: (context, index) {
                              Contact contact = state.contacts[index];
                              String contactInfo = '';
                              if (contact.phones.length > 0) {
                                contactInfo = contact.phones.first.value;
                              } else if (contact.emails.length > 0) {
                                contactInfo = contact.emails.first.value;
                              }
                              Uint8List image;
                              if (contact.hasAvatar) {
                                image = contact.avatar;
                              }
                              return Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Color(0xff07282D),
                                          width: 2,
                                        ),
                                      ),
                                      child: (contact.avatar != null && contact.avatar.isNotEmpty) ? CircleAvatar(
                                        backgroundImage: MemoryImage(contact.avatar),
                                      ) : CircleAvatar(
                                        child: Text(
                                          contact.initials(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'BackToSchool',
                                            fontSize: 24
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8,),
                                    Flexible(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          color: Color(0xff1B505E),
                                        ),
                                        padding: EdgeInsets.all(8),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            color: Color(0xFF256979),
                                          ),
                                          padding: EdgeInsets.all(6),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      contact.displayName ?? contact.familyName ?? '',
                                                      style: TextStyle(
                                                        fontFamily: 'BackToSchool',
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      contactInfo,
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(
                                                        fontFamily: 'BackToSchool',
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 8,),
                                              Container(
                                                height: 44,
                                                width: 100,
                                                child: SizedBox.expand(
                                                  child: MaterialButton(
                                                    onPressed: () {
                                                    },
                                                    minWidth: 0,
                                                    padding: EdgeInsets.zero,
                                                    child: Stack(
                                                      fit: StackFit.expand,
                                                      alignment: Alignment.center,
                                                      children: [
                                                        Image.asset('assets/images/btn_bg_yellow.png', fit: BoxFit.fill,),
                                                        Center(
                                                          child: Text(
                                                            'INVITE',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
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
                              );
                            },
                            separatorBuilder: (context, index){
                              return Divider(
                                color: Colors.transparent,
                              );
                            },
                            itemCount: state.contacts.length,
                            padding: EdgeInsets.only(top: 16, bottom: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
