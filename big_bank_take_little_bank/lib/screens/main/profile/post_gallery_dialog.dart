import 'dart:io';

import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/models/gallery_model.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PostGalleryDialog extends StatefulWidget {
  final File imageFile;
  final GalleryBloc galleryBloc;

  PostGalleryDialog({this.imageFile, this.galleryBloc});
  @override
  _PostGalleryDialogState createState() => new _PostGalleryDialogState();
}

class _PostGalleryDialogState extends State<PostGalleryDialog> {
  TextEditingController descriptionController = TextEditingController();
  FocusNode descriptionFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    descriptionFocus.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: widget.galleryBloc,
      listener: (BuildContext context, GalleryState state) async {
        if (state is GallerySuccess) {
          widget.galleryBloc.add(CheckGallery(userModel: Global.instance.userModel));
          Navigator.pop(context);
        } else if (state is GalleryFailure) {
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
      child: BlocBuilder<GalleryBloc, GalleryState>(
        cubit: widget.galleryBloc,
        builder: (BuildContext context, GalleryState state) {
          return _getBody(state);
        },
      ),
    );
  }
  Widget _getBody(GalleryState state) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Color(0xff0C343A),
                      ),
                      height: MediaQuery.of(context).size.height * 0.5,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Flexible(
                            flex: 3,
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
                                child: Image.file(widget.imageFile, fit: BoxFit.cover,),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                          ),
                          Container(
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Color(0xff07282D),
                            ),
                            padding: EdgeInsets.all(16),
                            child: SizedBox.expand(
                              child: TextField(
                                onChanged: (val) {

                                },
                                focusNode: descriptionFocus,
                                controller: descriptionController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                style: TextStyle(
                                  fontFamily: 'BackToSchool',
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Description',
                                ),
                                onSubmitted: (val) {
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
                    width: 264,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 44,
                          width: 120,
                          child: SizedBox.expand(
                            child: MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
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
                                      'CANCEL',
                                      style: TextStyle(
                                        fontFamily: 'BackToSchool',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Container(
                          height: 44,
                          width: 120,
                          child: SizedBox.expand(
                            child: state.isUploading ? Container(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ): MaterialButton(
                              onPressed: () {
                                GalleryModel galleryModel = GalleryModel();
                                galleryModel.id = FirebaseFirestore.instance.collection('users').doc(Global.instance.userId).collection('gallery').doc().id;
                                galleryModel.description = descriptionController.text;
                                widget.galleryBloc.add(CreateGalleryEvent(uid: Global.instance.userId, galleryModel: galleryModel, file: widget.imageFile));
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
                                      'PUBLISH',
                                      style: TextStyle(
                                        fontFamily: 'BackToSchool',
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
                  ),
                ],
              ),
            ),
            state.isUploading ? Positioned(
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
      ),
    );
  }
}
