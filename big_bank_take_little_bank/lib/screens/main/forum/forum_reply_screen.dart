import 'dart:io';

import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/models/chat_user_model.dart';
import 'package:big_bank_take_little_bank/models/comment_model.dart';
import 'package:big_bank_take_little_bank/models/gallery_model.dart';
import 'package:big_bank_take_little_bank/models/liket_model.dart';
import 'package:big_bank_take_little_bank/models/message_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:big_bank_take_little_bank/screens/main/forum/forum_message_cell.dart';
import 'package:big_bank_take_little_bank/screens/main/profile/comment_cell.dart';
import 'package:big_bank_take_little_bank/screens/main/profile/post_gallery_dialog.dart';
import 'package:big_bank_take_little_bank/utils/crop_image.dart';
import 'package:big_bank_take_little_bank/widgets/app_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timeago/timeago.dart' as timeago;

class ForumReplyScreen extends StatefulWidget {
  final MessageModel messageModel;
  final MessageBloc messageBloc;
  ForumReplyScreen({Key key, this.messageBloc, this.messageModel}) : super(key: key);

  @override
  _ForumReplyScreenState createState() => _ForumReplyScreenState();
}

class _ForumReplyScreenState extends State<ForumReplyScreen>  with SingleTickerProviderStateMixin {

  TextEditingController messageController = TextEditingController();
  FocusNode messageNode = FocusNode();

  @override
  void initState() {
    widget.messageBloc.add(ForumReplyInitEvent(model: widget.messageModel));
    super.initState();

  }

  @override
  void dispose() {
    messageController.dispose();
    messageNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: widget.messageBloc,
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
                )
              ],
            );
          });
        }
      },
      child: BlocBuilder<MessageBloc, MessageState>(
        cubit: widget.messageBloc,
        builder: (BuildContext context, MessageState state) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: _body(state),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 200,
                          padding: EdgeInsets.all(16),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Color(0xff0C343A),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: widget.messageModel.type == 'image' ? CropImage(
                                index: 0,
                                albumn: [widget.messageModel.message ?? ''],
                                isVideo: false,
                                list: [widget.messageModel.message ?? ''],
                              ): Padding(
                                padding: EdgeInsets.all(8),
                                child: AppLabel(
                                  title: widget.messageModel.message,
                                  fontSize: 14,
                                  shadow: true,
                                ),
                              ),
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
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: ListView.separated(
                                    padding: EdgeInsets.all(8),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      MessageModel messageModel = state.replyMessageList[index];
                                      return ForumMessageCell(
                                        isReply: true,
                                        messageModel: messageModel,
                                        onTap: () {

                                        },
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return Divider(
                                        height: 8,
                                        thickness: 0,
                                        color: Colors.transparent,
                                      );
                                    },
                                    itemCount: state.replyMessageList.length,
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
                                if (messageController.text.isNotEmpty) {
                                  MessageModel model = MessageModel(
                                    message: messageController.text,
                                    user: ChatUser(
                                      userId: Global.instance.userId,
                                      userImage: Global.instance.userModel.image,
                                      userName: Global.instance.userModel.name,
                                    ),
                                    type: 'text',
                                    replyId: widget.messageModel.id,
                                  );
                                  widget.messageBloc.add(SendForumMessageEvent(messageModel: model));
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
                                  replyId: widget.messageModel.id,
                                  type: 'text',
                                );
                                widget.messageBloc.add(SendForumMessageEvent(messageModel: model));
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
          replyId: widget.messageModel.id,
        );
        widget.messageBloc.add(SendForumMessageEvent(messageModel: model));
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
                        replyId: widget.messageModel.id,
                      );
                      widget.messageBloc.add(SendForumMessageEvent(messageModel: model));
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
