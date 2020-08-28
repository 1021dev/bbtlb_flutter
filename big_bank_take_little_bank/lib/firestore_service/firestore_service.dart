import 'package:big_bank_take_little_bank/models/comment_model.dart';
import 'package:big_bank_take_little_bank/models/friends_model.dart';
import 'package:big_bank_take_little_bank/models/gallery_model.dart';
import 'package:big_bank_take_little_bank/models/liket_model.dart';
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
        .where('type', isEqualTo: 'daily')
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

  Stream<QuerySnapshot> streamFriends(String uid) {
    return userCollection
        .doc(uid)
        .collection('friends')
        .where('status', isEqualTo: 'accept')
        .orderBy('name', descending: true)
        .snapshots(includeMetadataChanges: true);
  }

  Stream<QuerySnapshot> streamFriendsRequests(String uid) {
    return userCollection
        .doc(uid)
        .collection('friends')
        .where('status', isEqualTo: 'pending')
        .where('receiver', isEqualTo: uid)
        .orderBy('createdAt')
        .snapshots(includeMetadataChanges: true);
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

  Stream<QuerySnapshot> streamAdsRewards(String uid) {
    return userCollection
        .doc(uid)
        .collection('rewards')
        .where('type', isEqualTo: 'ads')
        .orderBy('rewardsAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> streamGalleryList(String uid) {
    return userCollection
        .doc(uid)
        .collection('gallery')
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  Stream<GalleryModel> streamGalleryDetail(String uid, String galleryId) {
    return userCollection
        .doc(uid)
        .collection('gallery')
        .doc(galleryId)
        .snapshots().map((event) {
          GalleryModel galleryModel = GalleryModel.fromJson(event.data());
          galleryModel.reference = event.reference;
          return galleryModel;
    });
  }

  Stream<QuerySnapshot> streamLikes(String uid, String galleryId) {
    return userCollection
        .doc(uid)
        .collection('gallery')
        .doc(galleryId)
        .collection('likes')
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> streamComments(String uid, String galleryId) {
    return userCollection
        .doc(uid)
        .collection('gallery')
        .doc(galleryId)
        .collection('comments')
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  Future<void> addComment(String uid, String galleryId, CommentModel commentModel) async {
    await userCollection
        .doc(uid)
        .collection('gallery')
        .doc(galleryId)
        .collection('comments')
        .add(commentModel.toJson());
  }

  Future<void> updateLike(String uid, String galleryId, LikeModel likeModel) async {
    return userCollection
        .doc(uid)
        .collection('gallery')
        .doc(galleryId)
        .collection('likes')
        .doc(Global.instance.userId)
        .set(likeModel.toJson());
  }

  Future<void> createGallery(String uid, GalleryModel galleryModel) async {
    if (galleryModel.id != '') {
      return userCollection
          .doc(uid)
          .collection('gallery')
          .doc(galleryModel.id)
          .set(galleryModel.toJson());
    } else {
      return userCollection
          .doc(uid)
          .collection('gallery')
          .add(galleryModel.toJson());
    }
  }

  Future<void> updateGallery(String userId, GalleryModel galleryModel) async {
    if (galleryModel.reference != null) {
      return galleryModel.reference.update(galleryModel.toJson());
    } else {
      return userCollection.doc(userId).collection('gallery').doc(galleryModel.id).update(galleryModel.toJson());
    }
  }

  Future<void> deleteGallery(String userId, GalleryModel galleryModel) async {
    if (galleryModel.reference != null) {
      return galleryModel.reference.delete();
    } else {
      return userCollection.doc(userId).collection('gallery').doc(galleryModel.id).delete();
    }
  }

  Stream<DocumentSnapshot> streamUserLike(String uid, String galleryId) {
    return userCollection
        .doc(uid)
        .collection('gallery')
        .doc(galleryId)
        .collection('likes')
        .doc(Global.instance.userId)
        .snapshots();
  }

  Future<DocumentSnapshot> getUserLike(String uid, String galleryId) async {
    return userCollection
        .doc(uid)
        .collection('gallery')
        .doc(galleryId)
        .collection('likes')
        .doc(Global.instance.userId).get();
  }


}