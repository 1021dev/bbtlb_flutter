import 'dart:io';

import 'package:big_bank_take_little_bank/models/block_model.dart';
import 'package:big_bank_take_little_bank/models/challenge_model.dart';
import 'package:big_bank_take_little_bank/models/comment_model.dart';
import 'package:big_bank_take_little_bank/models/friends_model.dart';
import 'package:big_bank_take_little_bank/models/gallery_model.dart';
import 'package:big_bank_take_little_bank/models/liket_model.dart';
import 'package:big_bank_take_little_bank/models/message_model.dart';
import 'package:big_bank_take_little_bank/models/rewards_model.dart';
import 'package:big_bank_take_little_bank/models/user_model.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:big_bank_take_little_bank/utils/app_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreService {
  final userCollection = FirebaseFirestore.instance.collection('users');
  final challengeCollection = FirebaseFirestore.instance.collection('challenge');
  final chatCollection = FirebaseFirestore.instance.collection('chat');

  FirebaseStorage _firebaseStorage = FirebaseStorage(storageBucket: AppConstant.appBucketURI);
  StorageUploadTask _uploadTask;

  // User Manager
  Future<UserModel> getUserWithId(String id) async {
    DocumentSnapshot snap = await userCollection.doc(id).get();

    if (snap.data() == null) {
      return null;
    }
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
    return FirebaseFirestore.instance.collection('users').doc(Global.instance.userId).update(
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
        .where('isLoggedIn', isEqualTo: true)
        .where('points', isGreaterThan: 0)
        .orderBy('points')
        .snapshots().map((event) {
         List<UserModel> users = [];
       event.docs.forEach((element) {
         if (element.id != FirebaseAuth.instance.currentUser.uid) {
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
        .snapshots();
  }

  Stream<QuerySnapshot> streamFriendsRequests(String uid) {
    return userCollection
        .doc(uid)
        .collection('friends')
        .where('status', isEqualTo: 'pending')
        .where('receiver', isEqualTo: uid)
        .orderBy('createdAt')
        .snapshots();
  }

  Stream<QuerySnapshot> streamBlockList(String uid) {
    return userCollection
        .doc(uid)
        .collection('block')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<DocumentSnapshot> getFriend(String uid) async {
    return userCollection
        .doc(uid)
        .collection('friends')
        .doc(Global.instance.userId)
        .get();
  }

  Future<DocumentSnapshot> getBlock(String uid) async {
    return userCollection
        .doc(uid)
        .collection('block')
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

  Stream<DocumentSnapshot> streamBlock(String uid, String blockId) {
    return userCollection
        .doc(uid)
        .collection('block')
        .doc(blockId)
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

  Future<void> updateBlock(String userId, BlockModel blockModel) async {
    return userCollection
        .doc(userId)
        .collection('block')
        .doc(blockModel.id)
        .set(blockModel.toJson());
  }

  Future<void> deleteFriends(String userId, FriendsModel friendsModel) async {
    return userCollection
        .doc(userId)
        .collection('friends')
        .doc(friendsModel.id)
        .delete();
  }

  Future<void> deleteBlock(String userId, BlockModel blockModel) async {
    return userCollection
        .doc(userId)
        .collection('block')
        .doc(blockModel.id)
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
        .orderBy('updatedAt')
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

  Stream<QuerySnapshot> streamChallenges(String uid) {
    return challengeCollection
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> streamLiveChallenge(String uid) {
    return challengeCollection
        .where('type', isEqualTo: 'live')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> streamScheduleChallenges(String uid) {
    return challengeCollection
        .where('type', isEqualTo: 'schedule')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot> streamChallenge(String uid, String challengeId) {
    return challengeCollection
        .doc(challengeId)
        .snapshots();
  }

  Future<void> updateChallenge(String challengeId, Map<String, dynamic> body) async {
    return challengeCollection.doc(challengeId).update(body);
  }

  Stream<QuerySnapshot> streamRequestedChallenge(String uid) {
    return challengeCollection
        .where('sender', isEqualTo: Global.instance.userId)
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt',)
        .snapshots();
  }

  Stream<QuerySnapshot> streamReceivedChallenge(String uid) {
    return challengeCollection
        .where('receiver', isEqualTo: Global.instance.userId)
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt',)
        .snapshots();
  }

  Stream<QuerySnapshot> streamNotifications(String uid) {
    return userCollection
        .doc(uid)
        .collection('notifications')
        // .where('createdAt', isGreaterThan: DateTime.now().subtract(Duration(days: 30)))
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> readNotification(String uid, String notificationId) async {
    return userCollection
        .doc(uid)
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
  }

  Future<void> deleteNotification(String uid, String notificationId) async {
    return userCollection
        .doc(uid)
        .collection('notifications')
        .doc(notificationId)
        .delete();
  }

  Stream<QuerySnapshot> streamChallengeChat(ChallengeModel model) {
    return challengeCollection
        .doc(model.id)
        .collection('chat')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> sendChallengeMessage(String id, MessageModel model) async {
    return challengeCollection
        .doc(id)
        .collection('chat')
        .add(model.toJson()).then((value) => value.update({'id': value.id}));
  }

  Stream<QuerySnapshot> streamChatList(String uid) {
    return FirebaseFirestore.instance
        .collection('chats')
        .where('members', arrayContains: uid)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> streamChat(String uid) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(generateChatId(uid, Global.instance.userId))
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> streamForum() {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc('forum')
        .collection('messages')
        .where('replyId', isNull: true)
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> streamForumReply(String messageId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc('forum')
        .collection('messages')
        .where('replyId', isEqualTo: messageId)
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  Stream<DocumentSnapshot> streamForumUsers() {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc('forum').snapshots();
  }

  getChats(String uid) {
    return FirebaseFirestore.instance
        .collection('chats')
        .where('members', arrayContains: uid)
        .orderBy('lastActive', descending: true)
        .snapshots();
  }

  generateChatId(String username1, String username2) {
    return username1.toString().compareTo(username2.toString()) < 0
        ? username1.toString() + '-' + username2.toString()
        : username2.toString() + '-' + username1.toString();
  }

  Future<bool> checkChatExistsOrNot(String username1, String username2) async {
    String chatId = generateChatId(username1, username2);
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('chats').doc(chatId).get();
    return doc.exists;
  }

  Future<bool> checkChatRoom(String roomId) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('chats').doc(roomId).get();
    return doc.exists;
  }

  sendMessage({String roomId, String userId, MessageModel model}) async {
    bool existsOrNot = await checkChatRoom(roomId);
    FirebaseFirestore tempDb = FirebaseFirestore.instance;
    Timestamp now = Timestamp.now();
    if (!existsOrNot) {
      List<String> members = [userId, Global.instance.userId];
      DocumentReference ref = model.type == 'text'
          ? await tempDb
          .collection('chats')
          .doc(roomId)
          .collection('messages')
          .add(model.toJson())
          : await tempDb
          .collection('chats')
          .doc(roomId)
          .collection('messages')
          .add(model.toJson());
      await tempDb
          .collection('chats')
          .doc(roomId)
          .set({'updatedAt': now, 'createdAt': now, 'members': members});
      await ref.update({'id': ref.id});
    } else {
      DocumentReference ref = model.type == 'text'
          ? await tempDb
          .collection('chats')
          .doc(roomId)
          .collection('messages')
          .add(model.toJson())
          : await tempDb
          .collection('chats')
          .doc(roomId)
          .collection('messages')
          .add(model.toJson());
      await ref.update({'id': ref.id});
      await tempDb.collection('chats').doc(roomId).update({'updatedAt': now});
    }
  }

  updateMessage({String id}) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('chats').doc('forum').collection('messages').doc(id).get();
    int count = doc.data()['replyCount'] ?? 0;

    print(count);
    return await doc.reference.update({
      'replyCount': count + 1,
    });
  }

  sendForumMessage({MessageModel model}) async {
    FirebaseFirestore tempDb = FirebaseFirestore.instance;
    Timestamp now = Timestamp.now();
    DocumentReference ref = await tempDb
        .collection('chats')
        .doc('forum')
        .collection('messages')
        .add(model.toJson());
    await ref.update({'id': ref.id});
    await tempDb.collection('chats').doc('forum').update({'updatedAt': now});
  }

  updateForum({List<String> users}) async {
    FirebaseFirestore tempDb = FirebaseFirestore.instance;
    Timestamp now = Timestamp.now();
    await tempDb.collection('chats').doc('forum').update({'users': users, 'updatedAt': now});
  }

  uploadImage(File _image, String to, String from) {
    String filePath =
        'chatImages/${generateChatId(to, from)}/${DateTime.now()}.png';
    _uploadTask = _firebaseStorage.ref().child(filePath).putFile(_image);
    return _uploadTask;
  }

  uploadForumImage(File _image) {
    String filePath =
        'chatImages/forum/${DateTime.now()}.png';
    _uploadTask = _firebaseStorage.ref().child(filePath).putFile(_image);
    return _uploadTask;
  }

  getURLforImage(String imagePath) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference sRef =
    await storage.getReferenceFromUrl(AppConstant.appBucketURI);
    StorageReference pathReference = sRef.child(imagePath);
    return await pathReference.getDownloadURL();
  }

  Stream<List<UserModel>> streamForumUsersProfile(List<String> users) {
    return userCollection
        .where('id', whereIn: users)
        .orderBy('isOnline')
        .snapshots().map((event) {
      List<UserModel> users = [];
      event.docs.forEach((element) {
        if (element.id != FirebaseAuth.instance.currentUser.uid) {
          users.add(UserModel.fromJson(element.data()));
        }
      });

      return users;
    });
  }

}