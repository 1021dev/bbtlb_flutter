import 'dart:convert';
import 'dart:io';

import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:big_bank_take_little_bank/utils/app_color.dart';
import 'package:big_bank_take_little_bank/utils/app_constant.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebView extends StatefulWidget {
  final String selectedUrl;

  CustomWebView({this.selectedUrl});

  @override
  _CustomWebViewState createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  static final  String clientId = Global.instance.instagramClientId;
  static final String redirectUri = Global.instance.instagramRedirectUrl;
  static final String initialUrl = 'https://api.instagram.com/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUri&scope=user_profile,user_media&response_type=code';
  final authFunctionUrl = 'https://us-central1-bigbanktakelittlebank-95940.cloudfunctions.net/redirect';

  num _stackIndex = 1;

  void _signIn(String code) async {
    setState(() {
      _stackIndex = 2;
    });
    http.Response response = await http.post(
      authFunctionUrl + '?code=' + code,
      body: {},
    );
    print(response.toString());
    if (response.body != null) {
      print(response.statusCode);
      print(response.body);
      // dynamic decode = json.decode(response.body);
      dynamic decodedResult = json.decode(response.body);
      print(decodedResult);
      FirebaseAuth.instance.signInWithCustomToken(decodedResult['data']['token']()).then((UserCredential _authResult){
        print(_authResult);
      }).catchError((error){
        print('Unable to sign in using custom token');
      });
    }
      //-------Local Development------------
    //var result = await http.post(LOCAL_DEVELOPMENT_CLOUD_FUNCTION_URL+'?code=${code}');

    //-------Sample response --------
    // result.body = {
    //   'id': "Instagram id",
    //   'user_name': "Instagram username",
    //   'media_count' : "Instagram mediaCount",
    //   'account_type' : "Maybe PERSONAL, CREATOR, BUSSINESS",
    //   'token': "custom token from firebase"
    // }


  }

  @override
  void initState() {
    // TODO: implement initState
    FirebaseAuth.instance.signOut();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: Color(0xff0e5073),
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          'Instagram Login',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: IndexedStack(
        index: _stackIndex,
        children: <Widget>[
          WebView(
            initialUrl: initialUrl,
            navigationDelegate: (NavigationRequest request) {
              if(request.url.startsWith(redirectUri)){
                if(request.url.contains('error')){
                  // User didn't authorize
                  // ---------TODO---------------
                }
                var startIndex = request.url.indexOf('code=');
                var endIndex = request.url.lastIndexOf('#');
                var code = request.url.substring(startIndex + 5,endIndex);
                _signIn(code);
                //----------TODO------------

                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
            onPageStarted: (url){
              print("Page started " + url);
            },
            javascriptMode: JavascriptMode.unrestricted,
            gestureNavigationEnabled: true,
            initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
            onPageFinished: (url) {
              setState(() {
                _stackIndex = 0;
              });
            },
          ),
          Center(
            child: Text('Loading...'),
          ),
          Center(
            child: Text('Creating Profile...'),
          )
        ],
      ),
    );
  }
}
