import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:big_bank_take_little_bank/screens/main/profile/add_points_screen.dart';
import 'package:big_bank_take_little_bank/screens/main/profile/edit_profile_dialog.dart';
import 'package:big_bank_take_little_bank/screens/main/profile/gallery_screen.dart';
import 'package:big_bank_take_little_bank/screens/splash/splash_screen.dart';
import 'package:big_bank_take_little_bank/widgets/background_widget.dart';
import 'package:big_bank_take_little_bank/widgets/profile_image_view.dart';
import 'package:big_bank_take_little_bank/widgets/title_background_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';

class ProfileScreen extends StatefulWidget {
  final ProfileScreenBloc screenBloc;
  final BuildContext homeContext;
  ProfileScreen({Key key, this.screenBloc, this.homeContext}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>  with SingleTickerProviderStateMixin {

  bool isHelp = false;
  AnimationController controller;
  Animation<double> translation;
  Animation<double> scaleAnim;
  CurvedAnimation curvedAnimation;
  UserModel userModel;
  @override
  void initState() {
    super.initState();
    userModel = Global.instance.userModel;
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
          return Scaffold(
            body: _body(state),
          );
        },
      ),
    );
  }

  Widget _body(ProfileScreenState state) {
    double avatarSize = MediaQuery.of(context).size.width * 0.3;
    if (state.currentUser != null) {
      userModel = state.currentUser;
    }
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
          top: false,
          bottom: false,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: double.infinity,
            padding: EdgeInsets.only(left: 8, right: 8),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 64, top: 44),
              child: Column(
                children: [
                  SizedBox(height: 16,),
                  Container(
                    height: avatarSize,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/bg_avatar.png',
                            width: avatarSize,
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(right: 4, bottom: 4),
                            child: ProfileImageView(
                              imageUrl: userModel.image ?? '',
                              avatarSize: avatarSize - 16,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: MaterialButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {

                                  return EditProfileDialog(
                                    screenBloc: widget.screenBloc,
                                    userModel: userModel,
                                  );
                                },
                              );
                            },
                            minWidth: 0,
                            height: 44,
                            shape: CircleBorder(),
                            child: Image.asset(
                              'assets/images/profile_pencil.png',
                              height: 32,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16,),
                  Text(
                    userModel.name ?? '',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: 'BackToSchool'
                    ),
                  ),
                  SizedBox(height: 8,),
                  Text(
                    userModel.email ?? '',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'BackToSchool'
                    ),
                  ),
                  _badgeSection(state),
                  SizedBox(
                    height: 16,
                  ),
                  _detailSection(state),
                  SizedBox(
                    height: 16,
                  ),
                  _challengesSection(state),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    height: 55,
                    width: 725 / 175 * 55,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: Image.asset(
                          'assets/images/btn_gallery.png',
                          width: 725 / 175 * 55,
                          height: 55,
                          fit: BoxFit.fill,
                        ).image,
                      ),
                    ),
                    child: SizedBox.expand(
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.push(context, PageTransition(
                            child: GalleryScreen(
                              userModel: userModel,
                            ),
                            type: PageTransitionType.fade,
                            duration: Duration(microseconds: 300),
                          ));
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minWidth: 0,
                        height: 50,
                        padding: EdgeInsets.all(0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    height: 55,
                    width: 725 / 175 * 55,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: Image.asset(
                          'assets/images/btn_bg_yellow.png',
                          width: 725 / 175 * 55,
                          height: 55,
                          fit: BoxFit.fill,
                        ).image,
                      ),
                    ),
                    child: SizedBox.expand(
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              child: AddPointsScreen(
                                homeContext: widget.homeContext,
                              ),
                              type: PageTransitionType.fade,
                              duration: Duration(microseconds: 300),
                            ),
                          );
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minWidth: 0,
                        height: 50,
                        padding: EdgeInsets.all(0),
                        child: Text(
                          'ADD POINTS',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 24,
                            fontFamily: 'Lucky',
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    height: 55,
                    width: 725 / 175 * 55,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: Image.asset(
                          'assets/images/btn_bg_yellow.png',
                          width: 725 / 175 * 55,
                          height: 55,
                          fit: BoxFit.fill,
                        ).image,
                      ),
                    ),
                    child: SizedBox.expand(
                      child: MaterialButton(
                        onPressed: () {
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minWidth: 0,
                        height: 50,
                        padding: EdgeInsets.all(0),
                        child: Text(
                          'STATS',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 24,
                            fontFamily: 'Lucky',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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

  Widget _badgeSection(ProfileScreenState state) {
    return SizedBox(
      height: 250,
      child: Stack(
        alignment: Alignment.topCenter,
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 52,
            bottom: 0,
            left: 0,
            right: 0,
            child: BackgroundWidget(
              height: 200,
            ),
          ),
          Positioned(
            top: 25,
            height: 64,
            width: 160,
            child: TitleBackgroundWidget(
              title: 'BADGES',
              height: 64,
            ),
          ),
          Positioned(
            top: 0,
            height: 50,
            width: 190,
            child: Align(
              alignment: Alignment.topRight,
              child: Image.asset('assets/images/level_1_user_profile.png', width: 50, height: 50, fit: BoxFit.fill,),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailSection(ProfileScreenState state) {
    return SizedBox(
      height: 320,
      child: Stack(
        alignment: Alignment.topCenter,
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            bottom: 50,
            left: 0,
            right: 0,
            child: BackgroundWidget(
              height: 300,
            ),
          ),
          Positioned(
            top: 16,
            left: 0,
            right: 0,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color(0x60000000),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${userModel.points}',
                        style: TextStyle(
                          color: Color(0xFFF8A828),
                          fontSize: 20,
                          fontFamily: 'Lucky',
                        ),
                      ),
                      SizedBox(height: 16,),
                      Text(
                        'POINTS',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 24,),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color(0x60000000),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${userModel.totalPlayed}',
                        style: TextStyle(
                          color: Color(0xFF3AC3DC),
                          fontSize: 20,
                          fontFamily: 'Lucky',
                        ),
                      ),
                      SizedBox(height: 4,),
                      Text(
                        'GAMES\nPLAYED',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 132,
            height: 72,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0x60000000),
              ),
              padding: EdgeInsets.only(left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Age',
                        style: TextStyle(
                          color: Color(0xFF73878B),
                          fontSize: 18,
                          fontFamily: 'Cavier-Bold',
                        ),
                      ),
                      SizedBox(height: 8,),
                      Text(
                        '${userModel.age}',
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 18,
                          fontFamily: 'BackToSchool',
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Container(
                      width: 1,
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Location',
                        style: TextStyle(
                          color: Color(0xFF73878B),
                          fontSize: 18,
                          fontFamily: 'Cavier-Bold',
                        ),
                      ),
                      SizedBox(height: 8,),
                      Text(
                        userModel.location ?? '',
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 18,
                          fontFamily: 'BackToSchool',
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Container(
                      width: 1,
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Profession',
                        style: TextStyle(
                          color: Color(0xFF73878B),
                          fontSize: 18,
                          fontFamily: 'Cavier-Bold',
                        ),
                      ),
                      SizedBox(height: 8,),
                      Text(
                        userModel.profession ?? '',
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 18,
                          fontFamily: 'BackToSchool',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            height: 100,
            bottom: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color(0x60000000),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/level_1_challenger.png',
                            width: 32,
                            height: 32,
                            fit: BoxFit.fill,
                          ),
                          Image.asset(
                            'assets/images/hammer_im.png',
                            width: 24,
                            height: 24,
                            fit: BoxFit.fill,
                          ),
                        ],
                      ),
                      SizedBox(height: 8,),
                      Text(
                        '${userModel.totalWin}',
                        style: TextStyle(
                          color: Color(0xFF84B65B),
                          fontSize: 20,
                          fontFamily: 'Lucky',
                        ),
                      ),
                      SizedBox(height: 8,),
                      Flexible(
                        child: Text(
                          'WINS',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 24,),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color(0x60000000),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(
                            'assets/images/hammer_im.png',
                            width: 24,
                            height: 24,
                            fit: BoxFit.fill,
                          ),
                          Image.asset(
                            'assets/images/lossing_piggy.png',
                            width: 32,
                            height: 32,
                            fit: BoxFit.fill,
                          ),
                        ],
                      ),
                      SizedBox(height: 8,),
                      Text(
                        '${userModel.totalLoss}',
                        style: TextStyle(
                          color: Color(0xFFD741D9),
                          fontSize: 20,
                          fontFamily: 'Lucky',
                        ),
                      ),
                      SizedBox(height: 8,),
                      Flexible(
                        child: Text(
                          'LOSSES',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _challengesSection(ProfileScreenState state) {
    return SizedBox(
      height: 200,
      child: Stack(
        alignment: Alignment.topCenter,
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 24,
            bottom: 0,
            left: 0,
            right: 0,
            child: BackgroundWidget(
              height: 200,
            ),
          ),
          Positioned(
            top: 0,
            height: 64,
            width: 160,
            child: TitleBackgroundWidget(
              title: 'CHALLENGES',
              height: 64,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 16,),
                  Text(
                    '${userModel.totalRequest}',
                    style: TextStyle(
                      color: Color(0xFF19DC47),
                      fontSize: 20,
                      fontFamily: 'Lucky',
                    ),
                  ),
                  SizedBox(height: 16,),
                  Text(
                    'REQUESTED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Lucky',
                      shadows: [
                        Shadow(
                          color: Colors.black87,
                          offset: Offset(4.0, 4.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(width: 24,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 16,),
                  Text(
                    '${userModel.totalDecline}',
                    style: TextStyle(
                      color: Color(0xFFF3422E),
                      fontSize: 20,
                      fontFamily: 'Lucky',
                    ),
                  ),
                  SizedBox(height: 16,),
                  Text(
                    'DECLINED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Lucky',
                      shadows: [
                        Shadow(
                          color: Colors.black87,
                          offset: Offset(4.0, 4.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
