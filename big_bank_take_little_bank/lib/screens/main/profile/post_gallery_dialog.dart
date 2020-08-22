import 'dart:io';

import 'package:flutter/material.dart';

class PostGalleryDialog extends StatefulWidget {
  final File imageFile;

  PostGalleryDialog({this.imageFile});
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
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
                      Flexible(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Color(0xff07282D),
                          ),
                          padding: EdgeInsets.all(16),
                          child: Flexible(
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
                                contentPadding: EdgeInsets.all( 16),
                                border: InputBorder.none,
                                hintText: 'Description',
                              ),
                              onSubmitted: (val) {
                              },
                            ),
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
      ),
    );
  }
}
