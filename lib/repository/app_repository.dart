import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:laathi/features/companion/repository/companion_repository.dart';
import 'package:laathi/utils/show_bar.dart';
import 'package:flutter/material.dart';

// import '../utils/constants.dart';

final appRepositoryProvider = Provider((ref) => AppRepository(
      firebaseFirestore: FirebaseFirestore.instance,
      firebaseAuth: FirebaseAuth.instance,
    ));

class AppRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  User? currentUser;
  late final CollectionReference userCollection, chatCollection;
  late DocumentReference currentUserDocument;

  AppRepository({
    required this.firebaseFirestore,
    required this.firebaseAuth,
  }) {
    userCollection = firebaseFirestore.collection('users');
    chatCollection = firebaseFirestore.collection('chats');
    if (firebaseAuth.currentUser != null) {
      loginCurrentUser();
    }
    // companionCollection = userCollection
  }
  void loginCurrentUser() {
    currentUser = firebaseAuth.currentUser;
    currentUserDocument = userCollection.doc(currentUser!.uid);
  }

  void logoutCurrentUser() {
    currentUser = null;
  }

  Future<String> getUserId(String phoneNumber) async {
    QuerySnapshot snap = await getUserData(phoneNumber);
    // ignore: avoid_print
    print(snap.size);
    return (snap.size > 0) ? snap.docs[0].id : "";
  }

  Future registerUser(User user, String fullName) async {
    await saveUserData(user, fullName);
  }

  Future<void> fetchCompanions() async {
    QuerySnapshot snap = await getUserData(currentUser!.phoneNumber!);
    debugPrint("snap ${snap.size}");
    Map<String, String> companions = snap.docs[0]['providers'];
    for (MapEntry d in companions.entries) {
      debugPrint("${d.key} ${d.value}");
    }
  }

  Future<void> setCompanion(
      String name, String phoneNumber, BuildContext context) async {
    try {
      String id = await getUserId(phoneNumber);
      // ignore: avoid_print
      print(id);
      String currentUserName = "fullNameXYZ";
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get()
          .then((value) => {currentUserName = value['fullName']});

      // if already a companion exist with this no then dont add the companion again
      QuerySnapshot<Map<String, dynamic>> snapshot = await currentUserDocument
          .collection('providers')
          .where('phone', isEqualTo: phoneNumber)
          .get();
      if (snapshot.docs.isNotEmpty) {
        return;
      }

      if (id != "" && id != currentUser!.phoneNumber) {
        // updating into providers collection
        await currentUserDocument
            .collection('providers')
            .add({'name': name, 'phone': phoneNumber, 'id': id});

        //***************************************************************************** */
        // updating into beneficicaries collection
        // UPDATED CODE HERE BY ME
        debugPrint('$currentUserName   is the currentUserName    😎😎');
        await userCollection.doc(id).collection('beneficiaries').add(
          {
            // YAHA NAME WOULD COME
            'name': currentUserName,
            'phone': currentUser!.phoneNumber,
            'id': currentUser!.uid
          },
        );
        //
        QuerySnapshot snap = await fetchMessages(id);
        String? senderName;
        userCollection.doc(currentUser!.uid).get().then((value) {
          senderName = value['fullName'];
        });
        if (snap.size == 0) {
          await chatCollection.doc().set(
            {
              'users': [currentUser!.uid, id],
              'names': [
                {id: name},
                {currentUser!.uid, senderName}
              ]
            },
          );
        } else {
          await chatCollection.doc(snap.docs[0].id).set({
            'names': [
              {id: name},
              {currentUser!.uid, senderName}
            ]
          }, SetOptions(merge: true));
        }
      } else {
        throw Exception('User not registered on app');
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future saveUserData(User user, String fullName) async {
    await userCollection.doc(user.uid).set({
      'fullName': fullName,
      'phone': user.phoneNumber!,
      'uid': user.uid,
    });
  }

  Future<QuerySnapshot> getUserData(String phoneNumber) async {
    QuerySnapshot snapshot =
        await userCollection.where('phone', isEqualTo: phoneNumber).get();
    return snapshot;
  }

  Query messageQuery(String uid) {
    return chatCollection.where('users', whereIn: [
      [currentUser!.uid, uid],
      [uid, currentUser!.uid]
    ]);
  }

  Future<Stream<QuerySnapshot>> getMessagesStream(String id) async {
    QuerySnapshot snapshot = await fetchMessages(id);
    return chatCollection
        .doc(snapshot.docs[0].id)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }

  Future<QuerySnapshot> fetchMessages(String uid) async {
    QuerySnapshot snapshot = await messageQuery(uid).get();
    return snapshot;
  }
}
