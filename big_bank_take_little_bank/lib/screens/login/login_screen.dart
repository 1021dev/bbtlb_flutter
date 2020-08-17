import 'package:big_bank_take_little_bank/utils/app_asset.dart';
import 'package:big_bank_take_little_bank/utils/app_color.dart';
import 'package:big_bank_take_little_bank/utils/app_helper.dart';
import 'package:big_bank_take_little_bank/utils/app_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController searchCountryController = TextEditingController();
  int position = 234;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.redColor,
      resizeToAvoidBottomInset: false,
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: GestureDetector(
          child: Stack(
            children: [
              Image.asset('assets/images/bg_signin.png', fit: BoxFit.fill,),
              Column(
                children: <Widget>[
                  _buildHeader(context),
                  _buildBody(context),
                ],
              ),
            ],
          ),
          onTap: () {
            FocusScope.of(context).unfocus();
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16,),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: AppHelper.getHeightFromScreenSize(context, 44)),
              TextField(

              ),
              SizedBox(height: AppHelper.getHeightFromScreenSize(context, 32)),
              SizedBox(height: AppHelper.getHeightFromScreenSize(context, 32)),
              SizedBox(height: AppHelper.getHeightFromScreenSize(context, 32)),
            ],
          ),
        ),
      ),
    );
  }


}
