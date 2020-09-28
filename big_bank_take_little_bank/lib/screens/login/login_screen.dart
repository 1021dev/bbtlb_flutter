import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/screens/main/main_screen.dart';
import 'package:big_bank_take_little_bank/screens/register/register_screen.dart';
import 'package:big_bank_take_little_bank/utils/app_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:toast/toast.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  LoginScreenBloc screenBloc;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    screenBloc = new LoginScreenBloc(LoginScreenState());
    screenBloc.add(LoginScreenInitEvent());
    super.initState();
    // emailController.text = 'davis5.tony7@gmail.com';
    // passwordController.text = 'aidsyd112';
  }

  @override
  void dispose() {
    screenBloc.close();
    emailController.dispose();
    emailFocus.dispose();
    passwordController.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: screenBloc,
      listener: (BuildContext context, LoginScreenState state) async {
        if (state is LoginScreenSuccess) {

          Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade, child: MainScreen()));
        } else if (state is LoginScreenFailure) {
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
        } else if (state is LoginScreenPasswordResetSent) {
          showCupertinoDialog(context: context, builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text('Reset Password'),
              content: Text('Reset password link sent, please check your mailbox.'),
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
      child: BlocBuilder<LoginScreenBloc, LoginScreenState>(
        cubit: screenBloc,
        builder: (BuildContext context, LoginScreenState state) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_sign_in.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              body: _body(state),
            ),
          );
        },
      ),
    );
  }

  Widget _body(LoginScreenState state) {
//    if (state.email != null) {
//      emailController.text = state.email;
//      passwordController.text = state.password;
//    }
    return GestureDetector(
      child: Form(
        key: _formKey,
        child:  Stack(
          fit: StackFit.expand,
          children: [
            // Positioned(
            //   height: MediaQuery.of(context).size.height,
            //   width: MediaQuery.of(context).size.width,
            //   child: Image.asset('assets/images/bg_sign_in.png', fit: BoxFit.fill,),
            // ),
            SafeArea(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 36, right: 36),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size. height * 0.35,
                        child: Image.asset('assets/images/ic_text_logo.png'),
                      ),
                      Container(
                        height: 55,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset('assets/images/bg_text_field.png', fit: BoxFit.fill,),
                            TextField(
                              focusNode: emailFocus,
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              style: TextStyle(
                                fontFamily: 'BackToSchool',
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Image.asset('assets/images/email.png'),
                                contentPadding: EdgeInsets.all( 16),
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
                              controller: passwordController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              style: TextStyle(
                                fontFamily: 'BackToSchool',
                                color: Colors.white,
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
                              onSubmitted: (val) async {
                                FocusScope.of(context).unfocus();
                                _login();
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                      ),
                      Container(
                        height: 44,
                        alignment: Alignment.centerRight,
                        child: FlatButton(
                          onPressed: () {
                            String emailValid = AppHelper.emailValidate(emailController.text);
                            if (emailValid != null) {
                              Toast.show(emailValid, context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                              return;
                            }
                            screenBloc.add(ForgetPasswordEvent(email: emailController.text));

                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'BackToSchool'
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                      ),
                      Container(
                        height: 55,
                        child: SizedBox.expand(
                          child: MaterialButton(
                            onPressed: _login,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minWidth: 0,
                            height: 50,
                            padding: EdgeInsets.all(0),
                            child: Image.asset('assets/images/btn_login.png', fit: BoxFit.fill,),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Flexible(
                            flex: 1,
                            child: MaterialButton(
                              onPressed: () {

                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              minWidth: 0,
                              height: 50,
                              child: Image.asset('assets/images/btn_fb.png'),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: MaterialButton(
                              onPressed: () {

                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              minWidth: 0,
                              height: 50,
                              child: Image.asset('assets/images/btn_twitter.png'),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: MaterialButton(
                              onPressed: () {

                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              minWidth: 0,
                              height: 50,
                              child: Image.asset('assets/images/btn_google.png'),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                      ),
                      Container(
                        height: 55,
                        child: SizedBox.expand(
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.push(context, PageTransition(
                                child: RegisterScreen(),
                                type: PageTransitionType.fade,
                              ));
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minWidth: 0,
                            height: 50,
                            clipBehavior: Clip.antiAlias,
                            padding: EdgeInsets.all(0),
                            child: Image.asset('assets/images/btn_sign_up.png'),
                          ),
                        ),
                      ),
                    ],
                  ),
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
      ),
      onTap: () {
        FocusScope.of(context).unfocus();
      },
    );
  }

  _login() async {
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
    if (_formKey.currentState.validate()) {
      screenBloc.add(LoginUserEvent(email: emailController.text, password: passwordController.text));
    }
  }
}
