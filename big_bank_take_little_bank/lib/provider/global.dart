import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/my_app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  DocumentReference userRef;
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
    if (FirebaseAuth.instance.currentUser != null) {
      await firestore.collection('users').doc(FirebaseAuth.instance.currentUser.uid).update({'deviceToken': token});
    }
  }
}
