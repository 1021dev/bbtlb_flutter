import 'dart:io';

import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/models/comment_model.dart';
import 'package:big_bank_take_little_bank/models/gallery_model.dart';
import 'package:big_bank_take_little_bank/models/liket_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:big_bank_take_little_bank/screens/main/profile/comment_cell.dart';
import 'package:big_bank_take_little_bank/screens/main/profile/post_gallery_dialog.dart';
import 'package:big_bank_take_little_bank/utils/crop_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  TextEditingController descriptionController = TextEditingController();
  FocusNode messageNode = FocusNode();
  FocusNode descriptionNode = FocusNode();

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

    descriptionController.text = widget.galleryModel.description;
  }

  @override
  void dispose() {
    controller.dispose();
    messageController.dispose();
    messageNode.dispose();
    descriptionController.dispose();
    descriptionNode.dispose();
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
    return Stack(
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
          child: Image.asset('assets/images/bg_top_bar_trans.png', fit: BoxFit.fill,),
        ),
        SafeArea(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanDown: (_) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.5,
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
                                  Expanded(
                                    child: Container(
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
                                        child: CropImage(
                                          index: 0,
                                          albumn: [state is GalleryDetailLoadState ? state.galleryModel.image: ''],
                                          isVideo: false,
                                          list: [state is GalleryDetailLoadState ? state.galleryModel.image: ''],
                                        ),
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
                                                  color: Colors.white70,
                                              ),
                                            ),
                                            Text(
                                            state is GalleryDetailLoadState ? timeago.format(state.galleryModel.createdAt): '',
                                              style: TextStyle(
                                                fontFamily: 'BackToSchool',
                                                color: Colors.white60,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Flexible(
                                          child: EditableText(
                                            textAlign: TextAlign.left,
                                            focusNode: descriptionNode,
                                            controller: descriptionController,
                                            style: TextStyle(
                                              fontFamily: 'BackToSchool',
                                              fontSize: 16,
                                            ),
                                            keyboardType: TextInputType.multiline,
                                            cursorColor: Colors.white,
                                            backgroundCursorColor: Colors.transparent,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 50,
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
                                                    _likeGallery(state);
                                                  },
                                                  minWidth: 0,
                                                  padding: EdgeInsets.zero,
                                                  child: state is GalleryDetailLoadState
                                                      ? (isLike(state)
                                                      ? Image.asset('assets/images/ic_heart.png', width: 24, height: 24,)
                                                      : Image.asset('assets/images/ic_no_heart.png', width: 24, height: 24,))
                                                      : Image.asset('assets/images/ic_no_heart.png', width: 24, height: 24,),
                                                ),
                                                Text(
                                                  state is GalleryDetailLoadState ? '${state.galleryModel.likeCount} Likes': '0 Like',
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
                                                  minWidth: 0,
                                                  padding: EdgeInsets.zero,
                                                  child: Image.asset('assets/images/ic_comment.png', width: 24, height: 24,),
                                                ),
                                                Text(
                                                  state is GalleryDetailLoadState ? '${state.galleryModel.commentCount} Comments': '0 Comments',
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
                          Container(
                            height: MediaQuery.of(context).size.height * 0.5 - 100,
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
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: state is GalleryDetailLoadState ? ListView.separated(
                                    padding: EdgeInsets.all(8),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      CommentModel commentModel = state.commentList[index];
                                      return CommentCell(
                                        commentModel: commentModel,
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return Divider(
                                        height: 8,
                                        thickness: 0,
                                        color: Colors.transparent,
                                      );
                                    },
                                    itemCount: state.commentList.length,
                                  ): Container(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
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
                              if (messageController.text != '') {
                                CommentModel commentModel = CommentModel();
                                commentModel.comment = messageController.text;
                                commentModel.userId = Global.instance.userId;
                                commentModel.userName = Global.instance.userModel.name;
                                commentModel.userImage = Global.instance.userModel.image;
                                commentModel.id = FirebaseFirestore.instance.collection('users')
                                    .doc(Global.instance.userId).collection('gallery')
                                    .doc(widget.galleryModel.id).collection('comments')
                                    .doc().id;
                                galleryDetailBloc.add(
                                    AddCommentEvent(
                                      uid: widget.userModel.id,
                                      galleryId: widget.galleryModel.id,
                                      commentModel: commentModel,
                                    )
                                );
                              }
                              messageController.clear();
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
    );
  }

  bool isLike(GalleryDetailLoadState state) {
    List<LikeModel> likes = [];
    likes.addAll(state.likeList);
    List like = likes.where((element) => element.id == Global.instance.userId).toList();
    if (like.length > 0) {
      return like.first.like;
    } else {
      return false;
    }
  }

  _likeGallery(GalleryDetailLoadState state) {
    List<LikeModel> likes = [];
    likes.addAll(state.likeList);
    List like = likes.where((element) => element.id == Global.instance.userId).toList();
    if (like.length > 0) {
      LikeModel likeModel = like.first;
      likeModel.like = !likeModel.like;
      galleryDetailBloc.add(
          LikeEvent(
            galleryId: widget.galleryModel.id,
            uid: widget.userModel.id,
            likeModel: likeModel,
          )
      );
    } else {
      LikeModel likeModel = LikeModel(
        id: Global.instance.userId,
        userId: Global.instance.userId,
        like: true,
        userImage: Global.instance.userModel.image,
        userName: Global.instance.userModel.name
      );
      galleryDetailBloc.add(
          LikeEvent(
            galleryId: widget.galleryModel.id,
            uid: widget.userModel.id,
            likeModel: likeModel,
          )
      );
    }
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
