
import 'dart:io';

import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/models/chat_user_model.dart';
import 'package:big_bank_take_little_bank/models/message_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:big_bank_take_little_bank/screens/main/friends/other_user_profile_screen.dart';
import 'package:big_bank_take_little_bank/widgets/app_text.dart';
import 'package:big_bank_take_little_bank/widgets/make_circle.dart';
import 'package:big_bank_take_little_bank/widgets/profile_avatar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';

import 'forum_message_cell.dart';

class ForumScreen extends StatefulWidget {
  final MainScreenBloc screenBloc;
  ForumScreen({
    Key key,
    this.screenBloc,
  }) : super(key: key);

  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  MessageBloc messageBloc;
  SlidableController slidableController;
  TextEditingController messageController = TextEditingController();
  FocusNode messageNode;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    slidableController = SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );
    messageBloc = MessageBloc(MessageState());
    messageBloc.add(ForumInitEvent());
    super.initState();
  }

  @override
  void dispose() {
    messageBloc.close();
    super.dispose();
  }

  void handleSlideAnimationChanged(Animation<double> slideAnimation) {
    setState(() {
    });
  }

  void handleSlideIsOpenChanged(bool isOpen) {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: messageBloc,
      listener: (BuildContext context, MessageState state) async {
        if (state is MessageSuccess) {
        } else if (state is MessageFailure) {
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
                ),
              ],
            );
          });
        }
      },
      child: BlocBuilder<MessageBloc, MessageState>(
        cubit: messageBloc,
        builder: (BuildContext context, MessageState state) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              width: MediaQuery.of(context).size.height,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xffce5281),
                    Color(0xff6e1c83),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Container(
                width: MediaQuery.of(context).size.height,
                height: MediaQuery.of(context).size.height,
                decoration: MakeCircle(
                  strokeWidth: 36,
                  strokeCap: StrokeCap.square,
                ),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: _body(state),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _body(MessageState state) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: Image.asset('assets/images/bg_top_bar_trans.png', fit: BoxFit.fill,),
        ),
        SafeArea(
          maintainBottomViewPadding: false,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 80,
                left: 4,
                right: 8,
                height: 120,
                child: Container(
                  margin: EdgeInsets.only(top: 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF5c9c85),
                        Color(0xFF35777e),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                        spreadRadius: 1.0,
                        offset: Offset(
                          4.0,
                          4.0,
                        ),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.only(
                    left: 8,
                    top: 8,
                    bottom: 8,
                    right: 8,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF0e3d48),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: _usersList(state),
                  ),
                ),
              ),
              Positioned(
                top: 210,
                left: 4,
                right: 8,
                bottom: 48,
                child: Container(
                  margin: EdgeInsets.only(top: 0, bottom: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF5c9c85),
                        Color(0xFF35777e),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                        spreadRadius: 1.0,
                        offset: Offset(
                          4.0,
                          4.0,
                        ),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.only(
                    left: 12,
                    top: 14,
                    bottom: 16,
                    right: 12,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF0e3d48),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: _messageList(state),
                  ),
                ),
              ),
              // Positioned(
              //   top: 210,
              //   left: 4,
              //   right: 8,
              //   bottom: 44,
              //   child: ,
              // ),
              Positioned(
                top: 0,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Container(
                  height: 100,
                  child: Image.asset('assets/images/forum_top.png'),
                ),
              ),
            ],
          ),
        ),
        SafeArea(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 56,
                padding: EdgeInsets.only(left: 8, right: 8,),
                width: double.infinity,
                child: Image.asset('assets/images/message_background_field.png', fit: BoxFit.fill,),
              ),
              Container(
                height: 48,
                width: double.infinity,
                padding: EdgeInsets.only(left: 8, right: 8, bottom: 4),
                child: Image.asset('assets/images/message_field.png', fit: BoxFit.fill,),
              ),
              Container(
                padding: EdgeInsets.only(right: 8, left: 8, ),
                height: 50,
                child: Row(
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
                          if (val.isNotEmpty) {
                            MessageModel model = MessageModel(
                              message: val,
                              user: ChatUser(
                                userId: Global.instance.userId,
                                userImage: Global.instance.userModel.image,
                                userName: Global.instance.userModel.name,
                              ),
                              type: 'text',
                            );

                            messageBloc.add(SendForumMessageEvent(messageModel: model));
                          }
                          messageController.clear();
                        },
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        if (messageController.text.isNotEmpty) {
                          MessageModel model = MessageModel(
                            message: messageController.text,
                            user: ChatUser(
                              userId: Global.instance.userId,
                              userImage: Global.instance.userModel.image,
                              userName: Global.instance.userModel.name,
                            ),
                            type: 'text',
                          );

                          messageBloc.add(SendForumMessageEvent(messageModel: model));
                        }
                        messageController.clear();
                      },
                      padding: EdgeInsets.zero,
                      minWidth: 0,
                      height: 44,
                      shape: CircleBorder(),
                      child: Image.asset('assets/images/send_message.png'),
                    ),
                  ],
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
            child: Image.asset('assets/images/ic_back.png',),
            shape: CircleBorder(),
            minWidth: 0,
            padding: EdgeInsets.zero,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        Positioned(
          top: 44,
          right: 8,
          width: 55,
          height: 55,
          child: MaterialButton(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Image.asset('assets/images/attach.png', fit: BoxFit.cover,),
            ),
            shape: CircleBorder(),
            minWidth: 0,
            padding: EdgeInsets.zero,
            onPressed: () {
              showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) => _buildPopUpImagePicker(state, context),
              );
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
        ): Container(),
      ],
    );
  }

  Widget _usersList(MessageState state) {
    if (state.forumUsers.length == 0) {
      return Container();
    }
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemBuilder: (ctx, index) {
        String userId = state.forumUsers[index];
        return FutureBuilder(
          future: FirestoreService().getUserWithId(userId),
          builder: (context, snap) {
            UserModel user = snap.data;
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    child: OtherUserProfileScreen(
                      screenBloc: widget.screenBloc,
                      userModel: user,
                    ),
                    type: PageTransitionType.fade,
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(2),
                width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        ProfileAvatar(
                          avatarSize: 44,
                          image: user != null ? user.image ?? '': '',
                        ),
                        Container(
                          width: 16,
                          height: 16,
                          alignment: Alignment.bottomRight,
                          decoration: BoxDecoration(
                              color: user != null ? user.isOnline ? Colors.green: Colors.grey: Colors.grey,
                              border: Border.all(
                                color: Color(0xFF1b5c6b),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8)
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2,),
                    Flexible(
                      child: AppLabel(
                        title: user != null ? user.name ?? '': '',
                        fontSize: 12,
                        maxLine: 2,
                        shadow: true,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      separatorBuilder: (ctx, index) {
        return Container(width: 8,);
      },
      itemCount: state.forumUsers.length,
    );
  }

  Widget _messageList(MessageState state) {
    return Container(
      margin: EdgeInsets.all(4),
      child: ListView.separated(
        shrinkWrap: false,
        itemBuilder: (context, index) {
          return ForumMessageCell(
            messageModel: state.messageList[index],
            controller: slidableController,
            onDelete: () {
              print('delete message');
              messageBloc.add(DeleteMessageEvent(messageModel: state.messageList[index]));
            },
            onTap: () {

            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider(color: Colors.transparent,);
        },
        itemCount: state.messageList.length,
      ),
    );
  }

  Future getImage(int type) async {
    ImagePicker imagePicker = ImagePicker();
    var image = await imagePicker.getImage(
      source: type == 1 ? ImageSource.gallery : ImageSource.camera,
    );
    if (image != null) {
      return await _cropImage(File(image.path));
    }
  }

  Future<File> _cropImage(File imageFile) async {
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

    return croppedFile;
  }

  Widget _buildPopUpImagePicker(MessageState state, context) {
    File _imageFile;
    StorageUploadTask _taskUpload;
    bool uploadBool = false;
    if (_taskUpload != null)
      _taskUpload.onComplete.then((value) async {
        StorageReference sRef = value.ref;
        dynamic path = await sRef.getDownloadURL();
        MessageModel model = MessageModel(
          message: path,
          user: ChatUser(
            userId: Global.instance.userId,
            userImage: Global.instance.userModel.image,
            userName: Global.instance.userModel.name,
          ),
          type: 'image',
        );
        messageBloc.add(SendForumMessageEvent(messageModel: model));
        Navigator.pop(context);
      });

    return StatefulBuilder(
      builder: (context, setState) => CupertinoActionSheet(
        title: const Text('Choose Photo'),
        message: _imageFile == null ? const Text('Your options are ')
            : Container(
          height: MediaQuery.of(context).size.width * 0.6,
          width: MediaQuery.of(context).size.width * 0.6,
          child: Image.file(_imageFile),
        ),
        actions: <Widget>[
          if (!uploadBool) ...[
            if (_imageFile == null)
              CupertinoActionSheetAction(
                child: const Text('Take a Picture'),
                onPressed: () async {
                  File image = await getImage(0);
                  setState(() {
                    _imageFile = image;
                  });
                },
              ),
            if (_imageFile == null)
              CupertinoActionSheetAction(
                child: const Text('Camera Roll'),
                onPressed: () async {
                  File image = await getImage(1);
                  setState(() {
                    _imageFile = image;
                 });
                },
              ),
            if (_imageFile != null)
              CupertinoActionSheetAction(
                child: const Text('Send'),
                onPressed: () async {
                  if (_imageFile != null) {
                    _taskUpload = await FirestoreService().uploadForumImage(
                        File(_imageFile.path));
                    setState(() => uploadBool = true);
                  }
                },
              ),
            if (_imageFile != null)
              CupertinoActionSheetAction(
                child: const Text('Clear Selection'),
                onPressed: () => setState(() {
                  _imageFile = null;
                }),
              ),
          ] else ...[
            StreamBuilder<StorageTaskEvent>(
              stream: _taskUpload.events,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  StorageTaskEvent taskEvent = snapshot.data;
                  StorageTaskSnapshot event = snapshot.data.snapshot;
                  if (taskEvent.type == StorageTaskEventType.success) {
                    StorageReference sRef = event.ref;
                    sRef.getDownloadURL().then((path) async {
                      MessageModel model = MessageModel(
                        message: path,
                        user: ChatUser(
                          userId: Global.instance.userId,
                          userImage: Global.instance.userModel.image,
                          userName: Global.instance.userModel.name,
                        ),
                        type: 'image',
                      );
                      messageBloc.add(SendForumMessageEvent(messageModel: model));
                      Navigator.pop(context);
                    });
                  }
                }
                return Container(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ]
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
  }

}
