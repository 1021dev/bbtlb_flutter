import 'dart:io';

import 'package:big_bank_take_little_bank/blocs/auth/auth.dart';
import 'package:big_bank_take_little_bank/utils/app_color.dart';
import 'package:big_bank_take_little_bank/utils/app_helper.dart';
import 'package:big_bank_take_little_bank/widgets/input_done_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:page_transition/page_transition.dart';
import 'package:toast/toast.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController professionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  FocusNode userNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode ageFocus = FocusNode();
  FocusNode professionFocus = FocusNode();
  FocusNode locationFocus = FocusNode();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  OverlayEntry overlayEntry;

  AuthScreenBloc screenBloc;
  @override
  void initState() {
    screenBloc = AuthScreenBloc(AuthScreenState(isLoading: false));
    super.initState();
    ageFocus.addListener(() {
      bool hasFocus = ageFocus.hasFocus;
      if (hasFocus)
        showOverlay(context);
      else
        removeOverlay();
    });

    KeyboardVisibilityNotification().addNewListener(
      onHide: () {
        removeOverlay();
      },
    );

  }

  @override
  void dispose() {
    screenBloc.close();
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    ageController.dispose();
    professionController.dispose();
    locationController.dispose();

    userNameFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    ageFocus.dispose();
    professionFocus.dispose();
    locationFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: screenBloc,
      listener: (BuildContext context, AuthScreenState state) async {
        if (state is AuthScreenSuccess) {
          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: RegisterScreen()));
        } else if (state is AuthScreenFailure) {
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
        } else if (state is AuthEmailVerification) {
          showCupertinoDialog(context: context, builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text('BigBankTakeLittleBank'),
              content: Text('Email verification link sent, please check your inbox and login again'),
              actions: [
                CupertinoDialogAction(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
        }
      },
      child: BlocBuilder<AuthScreenBloc, AuthScreenState>(
        cubit: screenBloc,
        builder: (BuildContext context, AuthScreenState state) {
          return Scaffold(
            key: scaffoldKey,
            backgroundColor: AppColor.background,
            resizeToAvoidBottomInset: true,
            body: _body(state),
          );
        },
      ),
    );
  }

  Widget _body(AuthScreenState state) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        top: false,
        child: GestureDetector(
          child: Stack(
            children: [
              Positioned(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                top: 0.0,
                child: Image.asset('assets/images/bg_sign_up.png', fit: BoxFit.fill,),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(36),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: MediaQuery.of(context).size.height * 0.2,),
                      Image.asset(
                        'assets/images/text_logo.png',
                        width: MediaQuery.of(context).size.width * 0.5,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        height: 120,
                        width: 120,
                        margin: EdgeInsets.only(top: 16, bottom: 16),
                        child: SizedBox(
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(60),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 4,
                                  ),
                                  image: state.file != null ? DecorationImage(
                                    image:  Image.file(state.file).image,
                                  ): null,
                                ),
                              ),
                              Container(
                                height: 44,
                                width: 44,
                                child: SizedBox.expand(
                                  child: InkWell(
                                    onTap: () {
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
                                    child: Image.asset('assets/images/btn_camera.png', width: 44,height: 44,),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 55,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset('assets/images/bg_text_field.png', fit: BoxFit.fill,),
                            TextField(
                              focusNode: userNameFocus,
                              onChanged: (val) {

                              },
                              controller: userNameController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              style: TextStyle(
                                fontFamily: 'BackToSchool',
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Image.asset('assets/images/person.png'),
                                contentPadding: EdgeInsets.all( 16),
                                hintText: 'name',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                border: InputBorder.none,
                              ),
                              onSubmitted: (val) {
                                FocusScope.of(context).requestFocus(emailFocus);
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                      ),
                      Container(
                        height: 55,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset('assets/images/bg_text_field.png', fit: BoxFit.fill,),
                            TextField(
                              focusNode: emailFocus,
                              onChanged: (val) {

                              },
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              style: TextStyle(
                                fontFamily: 'BackToSchool',
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all( 16),
                                prefixIcon: Image.asset('assets/images/email.png'),
                                hintText: 'email',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                border: InputBorder.none,
                              ),
                              onSubmitted: (val) {
                                FocusScope.of(context).requestFocus(passwordFocus);
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                      ),
                      Container(
                        height: 55,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset('assets/images/bg_text_field.png', fit: BoxFit.fill,),
                            TextField(
                              focusNode: passwordFocus,
                              onChanged: (val) {

                              },
                              controller: passwordController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              style: TextStyle(
                                fontFamily: 'BackToSchool',
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all( 16),
                                prefixIcon: Image.asset('assets/images/password.png'),
                                hintText: 'password',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                border: InputBorder.none,
                              ),
                              obscureText: true,
                              onSubmitted: (val) {
                                FocusScope.of(context).requestFocus(ageFocus);
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                      ),
                      Container(
                        height: 55,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset('assets/images/bg_text_field.png', fit: BoxFit.fill,),
                            TextField(
                              focusNode: ageFocus,
                              onChanged: (val) {

                              },
                              controller: ageController,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              style: TextStyle(
                                fontFamily: 'BackToSchool',
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all( 16),
                                prefixIcon: Image.asset('assets/images/pencil.png'),
                                hintText: 'age',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                border: InputBorder.none,
                              ),
                              onSubmitted: (val) {
                                FocusScope.of(context).requestFocus(professionFocus);
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                      ),
                      Container(
                        height: 55,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset('assets/images/bg_text_field.png', fit: BoxFit.fill,),
                            TextField(
                              focusNode: professionFocus,
                              onChanged: (val) {

                              },
                              controller: professionController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              style: TextStyle(
                                fontFamily: 'BackToSchool',
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all( 16),
                                prefixIcon: Image.asset('assets/images/pencil.png'),
                                hintText: 'profession',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                border: InputBorder.none,
                              ),
                              onSubmitted: (val) {
                                FocusScope.of(context).requestFocus(locationFocus);
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                      ),
                      Container(
                        height: 55,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset('assets/images/bg_text_field.png', fit: BoxFit.fill,),
                            TextField(
                              focusNode: locationFocus,
                              onChanged: (val) {

                              },
                              controller: locationController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              style: TextStyle(
                                fontFamily: 'BackToSchool',
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all( 16),
                                prefixIcon: Image.asset('assets/images/gps.png'),
                                hintText: 'location',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                border: InputBorder.none,
                              ),
                              onSubmitted: (val) {
                                FocusScope.of(context).unfocus();
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                      ),
                      Container(
                        height: 55,
                        child: SizedBox.expand(
                          child: MaterialButton(
                            onPressed: _register,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minWidth: 0,
                            height: 60,
                            padding: EdgeInsets.all(0),
                            child: Image.asset('assets/images/btn_sign_up_yellow.png'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Already have an account?',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'BackToSchool',
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
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
          ),
          onTap: () {
            FocusScope.of(context).unfocus();
          },
        ),
      )
    );
  }

  _register() {
    if (userNameController.text.isEmpty) {
      Toast.show('User name required', context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      return;
    }
    String emailValid = AppHelper.emailValidate(emailController.text);
    String passwordValid = AppHelper.passwordValid(passwordController.text);
    if (emailValid != null) {
      Toast.show(emailValid, context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      return;
    }
    if (passwordValid != null) {
      Toast.show(passwordValid, context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      return;
    }
    if (ageController.text.isEmpty) {
      Toast.show('Age required', context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      return;
    }
    if (professionController.text.isEmpty) {
      Toast.show('Profession required', context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      return;
    }
    if (locationController.text.isEmpty) {
      Toast.show('Location required', context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      return;
    }

    screenBloc.add(RegisterUserEvent(
      email: emailController.text,
      password: passwordController.text,
      name: userNameController.text,
      age: int.parse(ageController.text),
      location: locationController.text,
      profession: professionController.text,
    ));
  }

  showOverlay(BuildContext context) {
    if (overlayEntry != null) return;
    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 0.0,
          left: 0.0,
          child: InputDoneView());
    });

    overlayState.insert(overlayEntry);
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
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
      screenBloc.add(AddAuthProfileImageEvent(file: croppedFile));
    }

  }
}
