import 'dart:io';

import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/widgets/profile_image_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

class EditProfileDialog extends StatefulWidget {
  final ProfileScreenBloc screenBloc;
  final UserModel userModel;
  EditProfileDialog({this.screenBloc, this.userModel});
  @override
  _EditProfileDialogState createState() => new _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController professionController = TextEditingController();
  FocusNode userNameFocus = FocusNode();
  FocusNode ageFocus = FocusNode();
  FocusNode professionFocus = FocusNode();
  FocusNode locationFocus = FocusNode();

  @override
  void initState() {
    nameController.text = widget.userModel.name ?? '';
    ageController.text = '${widget.userModel.age ?? 0}';
    locationController.text = widget.userModel.location ?? '';
    professionController.text = widget.userModel.profession ?? '';
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    locationController.dispose();
    professionController.dispose();

    userNameFocus.dispose();
    ageFocus.dispose();
    locationFocus.dispose();
    professionFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: widget.screenBloc,
      listener: (BuildContext context, ProfileScreenState state) async {
        if (state is UploadProfileImageSuccess || state is ProfileScreenSuccess) {
          widget.screenBloc.add(ProfileScreenInitEvent());
          Navigator.pop(context);
        } else
        if (state is ProfileScreenFailure) {
          showCupertinoDialog(
              context: context, builder: (BuildContext context) {
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
          return Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.transparent,
                body: _body(state),
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
        },
      ),
    );
  }

  Widget _body(ProfileScreenState state) {
    double avatarSize = MediaQuery.of(context).size.width * 0.35;
    String imageUrl = state.currentUser != null ? state.currentUser.image ?? '': '';
    return SafeArea(
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: EdgeInsets.all(16),
          child: Stack(
            alignment: Alignment.topCenter,
            fit: StackFit.expand,
            children: [
              Positioned(
                top: avatarSize / 2,
                left: 0,
                right: 0,
                bottom: 8,
                child: Image.asset(
                  'assets/images/bg_profile.png',
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                height: avatarSize,
                child: Container(
                  width: avatarSize,
                  alignment: Alignment.center,
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
                        child: ProfileImageView(
                          imageUrl: imageUrl,
                          avatarSize: avatarSize - 16,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
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
                          height: 50,
                          shape: CircleBorder(),
                          child: Image.asset(
                            'assets/images/btn_camera.png',
                            height: 44,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: 44,
                  width: 734 / 193 * 44,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: Image.asset(
                        'assets/images/btn_save_info.png',
                        width: 734 / 193 * 44,
                        height: 44,
                        fit: BoxFit.fill,
                      ).image,
                    ),
                  ),
                  child: SizedBox.expand(
                    child: MaterialButton(
                      onPressed: () {
                        updateUserProfile(state);
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
              ),
              Positioned(
                top: 0,
                right: 0,
                child: MaterialButton(
                  child: Icon(Icons.close),
                  shape: CircleBorder(),
                  minWidth: 0,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Positioned(
                top: 136,
                bottom: 80,
                left: 36,
                right: 44,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 25,
                        child: Text(
                          'Name',
                          style: TextStyle(
                            color: Color(0xFF73878B),
                            fontSize: 18,
                            fontFamily: 'Cavier-Bold',
                          ),
                        ),
                      ),
                      Container(
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Color(0xFF124556),
                        ),
                        child: TextField(
                          onChanged: (val) {

                          },
                          focusNode: userNameFocus,
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(
                            fontFamily: 'BackToSchool',
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all( 16),
                            border: InputBorder.none,
                          ),
                          onSubmitted: (val) {
                            FocusScope.of(context).requestFocus(ageFocus);
                          },
                        ),
                      ),
                      Container(
                        height: 25,
                        child: Text(
                          'Age',
                          style: TextStyle(
                            color: Color(0xFF73878B),
                            fontSize: 18,
                            fontFamily: 'Cavier-Bold',
                          ),
                        ),
                      ),
                      Container(
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Color(0xFF124556),
                        ),
                        child: TextField(
                          onChanged: (val) {

                          },
                          controller: ageController,
                          focusNode: ageFocus,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(
                            fontFamily: 'BackToSchool',
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all( 16),
                            border: InputBorder.none,
                          ),
                          onSubmitted: (val) {
                            FocusScope.of(context).requestFocus(locationFocus);
                          },
                        ),
                      ),
                      Container(
                        height: 25,
                        child: Text(
                          'Location',
                          style: TextStyle(
                            color: Color(0xFF73878B),
                            fontSize: 18,
                            fontFamily: 'Cavier-Bold',
                          ),
                        ),
                      ),
                      Container(
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Color(0xFF124556),
                        ),
                        child: TextField(
                          onChanged: (val) {

                          },
                          controller: locationController,
                          focusNode: locationFocus,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(
                            fontFamily: 'BackToSchool',
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all( 16),
                            border: InputBorder.none,
                          ),
                          onSubmitted: (val) {
                            FocusScope.of(context).requestFocus(professionFocus);
                          },
                        ),
                      ),
                      Container(
                        height: 25,
                        child: Text(
                          'Profession',
                          style: TextStyle(
                            color: Color(0xFF73878B),
                            fontSize: 18,
                            fontFamily: 'Cavier-Bold',
                          ),
                        ),
                      ),
                      Container(
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Color(0xFF124556),
                        ),
                        child: TextField(
                          onChanged: (val) {
                          },
                          controller: professionController,
                          focusNode: professionFocus,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          style: TextStyle(
                            fontFamily: 'BackToSchool',
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all( 16),
                            border: InputBorder.none,
                          ),
                          onSubmitted: (val) {
                          },
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
    );
  }

  updateUserProfile(ProfileScreenState state) {
    if (nameController.text.isEmpty) {
      Toast.show('User name required', context);
      return;
    }

    UserModel userModel = state.currentUser;

    userModel.name = nameController.text ?? '';
    userModel.profession = professionController.text ?? '';
    userModel.location = locationController.text ?? '';
    userModel.age = int.parse(ageController.text) ?? 0;

    widget.screenBloc.add(UpdateProfileScreenEvent(userModel: userModel));
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
      widget.screenBloc.add(UploadProfileImageEvent(image: croppedFile));
    }

  }

}
