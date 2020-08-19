import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/my_app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final _userCollection = firestore.collection('users');
  // User Manager
  Future<UserModel> getUserWithId(String id) async {
    dynamic snap = await _userCollection.document(id).get();

    return UserModel.fromJson(snap);
  }

  Future<UserModel> getUserWithReference(DocumentReference reference) async {
    dynamic snap = await reference.get();

    return UserModel.fromJson(snap);
  }

  Future<void> createUser(UserModel userModel) async {
    return _userCollection
        .document(userModel.id)
        .setData(userModel.toJson());
  }

  Stream<UserModel> streamUser(String uid) {
    return _userCollection
        .document(uid)
        .snapshots()
        .map((event) => UserModel.fromJson(event.data));
  }

  Future<void> updateUser(String id, Map body) async {
    return _userCollection.document(id).updateData(body);
  }

}