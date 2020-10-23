import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/my_app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

/// Environment declare here
class Env {
  Env._({@required this.apiBaseUrl});

  final String apiBaseUrl;

  factory Env.dev() {
    return Env._(apiBaseUrl: "https://api.github.com");
  }
}

/// Global env
class Global extends ChangeNotifier{
  Global._private();

  static final Global instance = Global._private();
  String userId = '';
  UserModel userModel;
  BuildContext homeContext;

  String _pushToken;

  String get token {
    return _pushToken;
  }

  factory Global({Env environment}) {
    if (environment != null) {
      instance.env = environment;
    }
    return instance;
  }

  Env env;
  void setToken(String token) async {
    _pushToken = token;
    if (FirebaseAuth != null) {
      if (FirebaseAuth.instance.currentUser != null && (token ?? '') != '') {
        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).update({'deviceToken': token});
      }
    }
  }

  void updatePushToken() async {
    if (FirebaseAuth != null) {
      if (FirebaseAuth.instance.currentUser != null && (token ?? '') != '') {
        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).update({'deviceToken': token});
      }
    }
  }
  String fbId = '2429866657105129';
  String fbRedirectUrl = '//www.facebook.com/connect/login_success.html';
  String instagramClientId = '697751964172815';
  String instagramClentSecret = 'd925f737dc36fcafb38508eb14cbd66a';
  // String instagramRedirectUrl = 'https://bigbanktakelittlebank-95940.firebaseapp.com/popup.html';
  String instagramRedirectUrl = 'https://www.bigbanktakelittlebank.net/auth/';

  //Twitter accessToken 1040307659721760768-39fQ81Ib9lY62KrNKfJXQoqU9tQsHZ
  //Twitter secret 6dsVbGH8RtJGuyUJXPMngtMdUVrUsaBMkbNzp51xfQyzD

// Instagram client ID  697751964172815
// Instagram Client Secret d925f737dc36fcafb38508eb14cbd66a
// Redirect Url https://www.bigbanktakelittlebank.net/
}
