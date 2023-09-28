import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laathi/utils/show_bar.dart';
import 'package:flutter/material.dart';

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
      if (id != "" && id != currentUser!.phoneNumber) {
        // updating into providers collection
        await currentUserDocument
            .collection('providers')
            .add({'name': name, 'phone': phoneNumber, 'id': id});

        //***************************************************************************** */
        // updating into beneficicaries collection
        // UPDATED CODE HERE BY ME
        await userCollection.doc(id).collection('beneficiaries').add(
          {
            // YAHA NAME WOULD COME
            'name': currentUser!.phoneNumber,
            'phone': currentUser!.phoneNumber,
            'id': currentUser!.uid
          },
        );
        QuerySnapshot snap = await fetchMessages(id);
        if (snap.size == 0) {
          await chatCollection.doc().set(
            {
              'users': [currentUser!.uid, id],
              'names': {id: name}
            },
          );
        } else {
          await chatCollection.doc(snap.docs[0].id).set({
            'names': {id: name}
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
