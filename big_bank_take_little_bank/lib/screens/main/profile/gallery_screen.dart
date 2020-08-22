import 'dart:io';

import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/screens/main/profile/edit_profile_dialog.dart';
import 'package:big_bank_take_little_bank/screens/main/profile/gallery_detail_screen.dart';
import 'package:big_bank_take_little_bank/screens/main/profile/post_gallery_dialog.dart';
import 'package:big_bank_take_little_bank/widgets/background_widget.dart';
import 'package:big_bank_take_little_bank/widgets/setting_cell.dart';
import 'package:big_bank_take_little_bank/widgets/title_background_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';

class GalleryScreen extends StatefulWidget {
  final ProfileScreenBloc screenBloc;
  GalleryScreen({Key key, this.screenBloc}) : super(key: key);

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen>  with SingleTickerProviderStateMixin {

  bool isHelp = false;
  AnimationController controller;
  Animation<double> translation;
  Animation<double> scaleAnim;
  CurvedAnimation curvedAnimation;

  bool isDeleteMode = false;
  @override
  void initState() {
    super.initState();
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
        }
      },
      child: BlocBuilder<ProfileScreenBloc, ProfileScreenState>(
        cubit: widget.screenBloc,
        builder: (BuildContext context, ProfileScreenState state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: _body(state),
          );
        },
      ),
    );
  }

  Widget _body(ProfileScreenState state) {

    double avatarSize = MediaQuery.of(context).size.width * 0.4;
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          bottom: 0,
          child: Image.asset('assets/images/bg_home.png',),
        ),
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: Image.asset('assets/images/bg_top.png',),
        ),
        SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: double.infinity,
            child: Column(
              children: [
                Container(
                  height: avatarSize,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/bg_points.png',
                          width: avatarSize,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/icon_gallery_top.png',
                          width: avatarSize,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: MaterialButton(
                          onPressed: () {
                            showCupertinoModalPopup(
                              context: context,
                              builder: (BuildContext context) => CupertinoActionSheet(
                                title: const Text('Choose Photo'),
                                message: const Text('Your options are '),
                                actions: <Widget>[
                                  CupertinoActionSheetAction(
                                    child: const Text('Take a Picture'),
                                    onPressed: () {
                                      Navigator.pop(context, 'Take a Picture');
                                      getImage(0);
                                    },
                                  ),
                                  CupertinoActionSheetAction(
                                    child: const Text('Camera Roll'),
                                    onPressed: () {
                                      Navigator.pop(context, 'Camera Roll');
                                      getImage(1);
                                    },
                                  )
                                ],
                                cancelButton: CupertinoActionSheetAction(
                                  child: const Text('Cancel'),
                                  isDefaultAction: true,
                                  onPressed: () {
                                    Navigator.pop(context, 'Cancel');
                                  },
                                ),
                              ),
                            );
                          },
                          minWidth: 0,
                          height: 44,
                          shape: CircleBorder(),
                          child: Image.asset(
                            'assets/images/ic_camera.png',
                            height: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Positioned(
                        top: 16,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Image.asset('assets/images/bg_profile.png', fit: BoxFit.fill,),
                      ),
                      Positioned(
                        top: 0,
                        height: 50,
                        child: Image.asset('assets/images/gallery_head.png', fit: BoxFit.fill,),
                      ),
                      Positioned(
                        top: 0,
                        right: 24,
                        width: 44,
                        height: 44,
                        child: MaterialButton(
                          onPressed: () {
                            setState(() {
                              isDeleteMode = !isDeleteMode;
                            });
                          },
                          minWidth: 0,
                          shape: CircleBorder(),
                          padding: EdgeInsets.zero,
                          child: Image.asset('assets/images/btn_dust.png'),
                        ),
                      ),
                      Positioned(
                        top: 56,
                        right: 40,
                        left: 30,
                        bottom: 100,
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            children: List.generate(10, (index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(context, PageTransition(
                                    child: GalleryDetailScreen(
                                      screenBloc: widget.screenBloc,
                                    ),
                                    type: PageTransitionType.fade,
                                    duration: Duration(microseconds: 300),
                                  ));
                                },
                                child: Stack(
                                  fit: StackFit.expand,
                                  alignment: Alignment.topRight,
                                  children: [
                                    Container(
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: Image.asset('assets/images/bg_gallery_item.png').image,
                                                ),
                                              ),
                                              padding: EdgeInsets.only(left: 8, right: 12, top: 12, bottom: 16),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(16),
                                                  image: DecorationImage(
                                                    image: Image.asset('assets/images/lossing_piggy.png').image,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 8,),
                                          Container(
                                            height: 32,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF0F484E),
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  flex: 1,
                                                  child: Row(
                                                    children: [
                                                      MaterialButton(
                                                        onPressed: () {

                                                        },
                                                        minWidth: 0,
                                                        padding: EdgeInsets.zero,
                                                        child: Image.asset('assets/images/heart.png', width: 24, height: 24,),
                                                      ),
                                                      Text(
                                                        '0',
                                                        style: TextStyle(
                                                          fontFamily: 'BackToSchool',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 1,
                                                  child: Row(
                                                    children: [
                                                      MaterialButton(
                                                        onPressed: () {

                                                        },
                                                        minWidth: 0,
                                                        padding: EdgeInsets.zero,
                                                        child: Image.asset('assets/images/ic_comment.png', width: 24, height: 24,),
                                                      ),
                                                      Text(
                                                        '0',
                                                        style: TextStyle(
                                                          fontFamily: 'BackToSchool',
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
                                    ),
                                    isDeleteMode ? Positioned(
                                      top: 0,
                                      right: 0,
                                      child: MaterialButton(
                                        onPressed: () {
                                        },
                                        child: Image.asset('assets/images/btn_remove.png', width: 24, height: 24,),
                                        shape: CircleBorder(),
                                        padding: EdgeInsets.zero,
                                        minWidth: 0,
                                        height: 36,
                                      ),
                                    ): Container(),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ],
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

  Future getImage(int type) async {
    ImagePicker imagePicker = ImagePicker();
    var image = await imagePicker.getImage(
      source: type == 1 ? ImageSource.gallery : ImageSource.camera,
    );
    if (image != null) {
      await _cropImage(File(image.path));
    }
  }

  Future<Null> _cropImage(File imageFile) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ]
            : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));

    if (croppedFile != null) {
      showDialog(
        context: context,
        builder: (_) {
          return PostGalleryDialog(
            imageFile: croppedFile,
          );
        },
      );
    }

  }

}
