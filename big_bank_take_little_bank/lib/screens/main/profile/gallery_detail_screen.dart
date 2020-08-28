import 'dart:io';

import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/models/gallery_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/screens/main/profile/post_gallery_dialog.dart';
import 'package:big_bank_take_little_bank/widgets/gallery_image_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timeago/timeago.dart' as timeago;

class GalleryDetailScreen extends StatefulWidget {
  final GalleryModel galleryModel;
  final UserModel userModel;
  GalleryDetailScreen({Key key, this.galleryModel, this.userModel}) : super(key: key);

  @override
  _GalleryDetailScreenState createState() => _GalleryDetailScreenState();
}

class _GalleryDetailScreenState extends State<GalleryDetailScreen>  with SingleTickerProviderStateMixin {

  bool isHelp = false;
  AnimationController controller;
  Animation<double> translation;
  Animation<double> scaleAnim;
  CurvedAnimation curvedAnimation;
  TextEditingController messageController = TextEditingController();
  FocusNode messageNode = FocusNode();

  GalleryDetailBloc galleryDetailBloc;
  @override
  void initState() {
    galleryDetailBloc = GalleryDetailBloc(GalleryDetailInitState());
    galleryDetailBloc.add(CheckGalleryDetail(userModel: widget.userModel, galleryModel: widget.galleryModel));
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
    messageController.dispose();
    messageNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: galleryDetailBloc,
      listener: (BuildContext context, GalleryDetailState state) async {
        if (state is GalleryDetailSuccess) {
        } else if (state is GalleryDetailFailure) {
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
      child: BlocBuilder<GalleryDetailBloc, GalleryDetailState>(
        cubit: galleryDetailBloc,
        builder: (BuildContext context, GalleryDetailState state) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: _body(state),
          );
        },
      ),
    );
  }

  Widget _body(GalleryDetailState state) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
            child: Image.asset('assets/images/bg_home.png', width: double.infinity, height: double.infinity, fit: BoxFit.fitWidth,),
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Image.asset('assets/images/bg_top.png',),
          ),
          SafeArea(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Color(0xff0C343A),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Color(0xff174951),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white,
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: GalleryImageView(
                                imageUrl: widget.galleryModel.image,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Color(0xff07282D),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Description',
                                      style: TextStyle(
                                          fontFamily: 'BackToSchool',
                                          color: Colors.white70
                                      ),
                                    ),
                                    Text(
                                      timeago.format(widget.galleryModel.createdAt),
                                      style: TextStyle(
                                        fontFamily: 'BackToSchool',
                                        color: Colors.white60,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                Flexible(
                                  child: Text(
                                    widget.galleryModel.description,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: 'BackToSchool',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 64,
                            padding: EdgeInsets.only(top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Color(0xff07282D),
                                    ),
                                    child: Row(
                                      children: [
                                        MaterialButton(
                                          onPressed: () {

                                          },
                                          minWidth: 0,
                                          padding: EdgeInsets.zero,
                                          child: Image.asset('assets/images/ic_no_heart.png', width: 24, height: 24,),
                                        ),
                                        Text(
                                          '${widget.galleryModel.likeCount} Likes',
                                          style: TextStyle(
                                            fontFamily: 'BackToSchool',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Color(0xff07282D),
                                    ),
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
                                          '${widget.galleryModel.likeCount} Comments',
                                          style: TextStyle(
                                            fontFamily: 'BackToSchool',
                                          ),
                                        ),
                                      ],
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
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Color(0xff0C343A),
                        ),
                        padding: EdgeInsets.all(12),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Color(0xff174951),
                          ),
                          padding: EdgeInsets.all(12),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            clipBehavior: Clip.antiAlias,
                            padding: EdgeInsets.only(bottom: 16),
                            child: ListView.separated(
                              itemBuilder: (context, index) {
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
                                            )
                                        ),
                                        child: Container(),
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
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      'John',
                                                      style: TextStyle(
                                                        fontFamily: 'BackToSchool',
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    Text(
                                                      '11/01/1011',
                                                      style: TextStyle(
                                                        fontFamily: 'BackToSchool',
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  'This is cool',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontFamily: 'BackToSchool',
                                                    fontSize: 14,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return Divider(
                                  height: 8,
                                  thickness: 0,
                                  color: Colors.transparent,
                                );
                              },
                              itemCount: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              child: Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                height: 50,
                child: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.centerRight,
                  children: [
                    Image.asset('assets/images/bg_text_field.png', width: double.infinity, fit: BoxFit.fill,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: TextField(
                            focusNode: messageNode,
                            onChanged: (val) {

                            },
                            controller: messageController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.send,
                            style: TextStyle(
                              fontFamily: 'BackToSchool',
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all( 16),
                              prefixIcon: Image.asset('assets/images/pencil.png'),
                              hintText: 'Add comment',
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              border: InputBorder.none,
                            ),
                            onSubmitted: (val) {
                            },
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {

                          },
                          padding: EdgeInsets.zero,
                          minWidth: 0,
                          height: 50,
                          shape: CircleBorder(),
                          child: Image.asset('assets/images/btn_send.png'),
                        ),
                      ],
                    )
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
          state is GalleryDetailInitState ? Positioned(
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
      ),
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
