import 'dart:io';

import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/widgets/profile_image_view.dart';
import 'package:big_bank_take_little_bank/widgets/title_background_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

class ChangePasswordDialog extends StatefulWidget {
  final ProfileScreenBloc screenBloc;
  final UserModel userModel;
  ChangePasswordDialog({this.screenBloc, this.userModel});
  @override
  _ChangePasswordDialogState createState() => new _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  TextEditingController oldController = TextEditingController();
  TextEditingController newController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  FocusNode oldFocus = FocusNode();
  FocusNode newFocus = FocusNode();
  FocusNode confirmFocus = FocusNode();

  @override
  void initState() {
    oldController.text = '';
    newController.text = '';
    confirmController.text = '';
    super.initState();
  }

  @override
  void dispose() {
    oldController.dispose();
    newController.dispose();
    confirmController.dispose();

    oldFocus.dispose();
    newFocus.dispose();
    confirmFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: widget.screenBloc,
      listener: (BuildContext context, ProfileScreenState state) async {
        if (state is UpdatePasswordSuccess) {
          showCupertinoDialog(
              context: context, builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text('Success'),
              content: Text('Password updated successfully, you must login again with new password.'),
              actions: [
                CupertinoDialogAction(
                  child: Text('Go to login'),
                  onPressed: () {
                    widget.screenBloc.add(ProfileScreenLogoutEvent());
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
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
    return SafeArea(
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: EdgeInsets.all(16),
          child: Stack(
            alignment: Alignment.topCenter,
            fit: StackFit.expand,
            children: [
              Positioned(
                top: 44,
                left: 0,
                right: 0,
                bottom: 8,
                child: Image.asset(
                  'assets/images/bg_profile.png',
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                top: 20,
                height: 64,
                width: 200,
                child: TitleBackgroundWidget(
                  title: 'Change Password',
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
                top: 100,
                bottom: 80,
                left: 36,
                right: 44,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 16),
                        child: Image.asset('assets/images/key_im.png', height: 80,),
                      ),
                      Container(
                        height: 55,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset('assets/images/bg_text_field.png', fit: BoxFit.fill,),
                            TextField(
                              focusNode: oldFocus,
                              onChanged: (val) {
                              },
                              controller: oldController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              style: TextStyle(
                                fontFamily: 'BackToSchool',
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all( 16),
                                hintText: 'Old Password',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                border: InputBorder.none,
                              ),
                              obscureText: true,
                              onSubmitted: (val) {
                                FocusScope.of(context).requestFocus(newFocus);
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 55,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset('assets/images/bg_text_field.png', fit: BoxFit.fill,),
                            TextField(
                              focusNode: newFocus,
                              onChanged: (val) {

                              },
                              controller: newController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              style: TextStyle(
                                fontFamily: 'BackToSchool',
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all( 16),
                                hintText: 'New Password',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                border: InputBorder.none,
                              ),
                              obscureText: true,
                              onSubmitted: (val) {
                                FocusScope.of(context).requestFocus(confirmFocus);
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 55,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset('assets/images/bg_text_field.png', fit: BoxFit.fill,),
                            TextField(
                              focusNode: confirmFocus,
                              onChanged: (val) {

                              },
                              controller: confirmController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              style: TextStyle(
                                fontFamily: 'BackToSchool',
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all( 16),
                                hintText: 'Confirm Password',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                border: InputBorder.none,
                              ),
                              obscureText: true,
                              onSubmitted: (val) {
                                FocusScope.of(context).unfocus();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: 50,
                  width: 120,
                  child: SizedBox.expand(
                    child: MaterialButton(
                      onPressed: () {
                        _updatePassword();
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
                              'Save',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _updatePassword() {
    if (oldController.text.isEmpty) {
      return 'Enter your old password';
    }
    if (newController.text.isEmpty) {
      return 'Enter your new password';
    }
    if (confirmController.text.isEmpty) {
      return 'Enter your confirm password';
    }
    if (newController.text.length < 8) {
      return 'Password length must be equal or longer than 8';
    }
    if (newController.text != confirmController.text) {
      return 'Enter your old password';
    }

    widget.screenBloc.add(UpdatePasswordEvent(oldPassword: oldController.text, newPassword: newController.text));
  }
}
