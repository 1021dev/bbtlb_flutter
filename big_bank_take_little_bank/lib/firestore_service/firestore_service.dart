import 'package:big_bank_take_little_bank/models/friends_model.dart';
import 'package:big_bank_take_little_bank/models/rewards_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/my_app.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final userCollection = firestore.collection('users');
  // User Manager
  Future<UserModel> getUserWithId(String id) async {
    DocumentSnapshot snap = await userCollection.doc(id).get();

    return UserModel.fromJson(snap.data());
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
    return userCollection
        .doc(uid)
        .snapshots()
        .map((event) {
      return UserModel.fromJson(event.data());
    });
  }

  Stream<DocumentSnapshot> streamSnap(String uid) {
    print(uid);
    return userCollection
        .doc(uid)
        .snapshots();
  }

  Future<void> updateUser(String id, Map<String, dynamic> body) async {
    return userCollection.doc(id).update(body);
  }

  Future<void> updateCurrentUser(Map<String, dynamic> body) async {
    body['updatedAt'] = Timestamp.now();
    return Global.instance.userRef.update(
      body,
    );
  }

  Stream<QuerySnapshot> streamLastRewards(String uid) {
    return userCollection
        .doc(uid)
        .collection('rewards')
        .orderBy('rewardsAt', descending: true)
        .limit(1)
        .snapshots();
  }

  Future<DocumentReference> addRewards(RewardsModel rewardsModel) async {
    return userCollection
        .doc(rewardsModel.id)
        .collection('rewards')
        .add(rewardsModel.toJson());
  }

  Stream<List<UserModel>> streamUsers() {
    return userCollection
//        .where('isLoggedIn', isEqualTo: true)
        .orderBy('createdAt')
        .snapshots().map((event) {
         List<UserModel> users = [];
       event.docs.forEach((element) {
         if (element.id != auth.currentUser.uid) {
           users.add(UserModel.fromJson(element.data()));
         }
       });

       return users;
    });
  }

  Stream<List<FriendsModel>> streamFriends(String uid) {
    return userCollection
        .doc(uid)
        .collection('friends')
        .orderBy('createdAt', descending: true)
        .snapshots().map((event) {
      List<FriendsModel> friends = [];
      event.docs.forEach((element) {
        friends.add(FriendsModel.fromJson(element.data()));
      });

      return friends;
    });
  }

  Future<DocumentSnapshot> getFriend(String uid) async {
    return userCollection
        .doc(uid)
        .collection('friends')
        .doc(Global.instance.userId)
        .get();
  }

  Stream<DocumentSnapshot> streamFriend(String uid, String friendId) {
    return userCollection
        .doc(uid)
        .collection('friends')
        .doc(friendId)
        .snapshots();
  }

  Future<void> addFriends(String userId, FriendsModel friendsModel) async {
    return userCollection
        .doc(userId)
        .collection('friends')
        .doc(friendsModel.id)
        .set(friendsModel.toJson(), SetOptions(merge: true));
  }

  Future<void> updateFriends(String userId, FriendsModel friendsModel) async {
    return userCollection
        .doc(userId)
        .collection('friends')
        .doc(friendsModel.id)
        .update(friendsModel.toJson());
  }

  Future<void> deleteFriends(String userId, FriendsModel friendsModel) async {
    return userCollection
        .doc(userId)
        .collection('friends')
        .doc(friendsModel.id)
        .delete();
  }



}