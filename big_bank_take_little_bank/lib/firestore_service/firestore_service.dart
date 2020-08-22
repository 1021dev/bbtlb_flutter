import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/my_app.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final userCollection = firestore.collection('users');
  // User Manager
  Future<UserModel> getUserWithId(String id) async {
    dynamic snap = await userCollection.doc(id).get();

    return UserModel.fromJson(snap);
  }

  Future<UserModel> getUserWithReference(DocumentReference reference) async {
    dynamic snap = await reference.get();

    return UserModel.fromJson(snap);
  }

  Future<void> createUser(UserModel userModel) async {
    return userCollection
        .doc(userModel.id)
        .set(userModel.toJson());
  }

  Stream<UserModel> streamUser(String uid) {
    print(uid);
    return userCollection
        .doc(uid)
        .snapshots()
        .map((event) {
      print(event.data);
      return UserModel.fromJson(event.data());
    });
  }

  Stream<DocumentSnapshot> streamSnap(String uid) {
    print(uid);
    return userCollection
        .doc(uid)
        .snapshots();
  }

  Future<void> updateUser(String id, Map body) async {
    return userCollection.doc(id).update(body);
  }

  Future<void> updateCurrentUser(Map body) async {
    body['updatedAt'] = Timestamp.now();
    return Global.instance.userRef.update(
      body,
    );
  }

}