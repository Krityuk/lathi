import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laathi/repository/app_repository.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository(
    ref.watch(appRepositoryProvider), FirebaseFirestore.instance));

class ChatRepository {
  // Access all the database functions using databaseRepository
  final AppRepository databaseRepository;
  final FirebaseFirestore firebaseFirestore;
  late final CollectionReference chatCollection;

  ChatRepository(this.databaseRepository, this.firebaseFirestore) {
    chatCollection = firebaseFirestore.collection('chats');
  }

  Future<Stream<QuerySnapshot>> getChatMessagesStream(String uid) async {
    Stream<QuerySnapshot> snap =
        await databaseRepository.getMessagesStream(uid);
    return snap;
  }

  //add a chat to the chats collection containing the current user and the user with given uid
  //TODO: implement this in frontend (currently only add companion is working)
  Future<void> addChat(String uid) async {
    await chatCollection.doc().set({
      'users': [databaseRepository.currentUser!.uid, uid]
    });
  }

  Future<void> sendMessage(String message, String user) async {
    QuerySnapshot snap = await databaseRepository.fetchMessages(user);
    chatCollection.doc(snap.docs[0].id).collection('messages').doc().set({
      'type': 'text',
      'content': message,
      'sender': databaseRepository.currentUser!.uid,
      'time': Timestamp.now(),
    });
  }

  Future<void> uploadAndSendMessage(
      String fileType, String filePath, String user) async {
    try {
      QuerySnapshot snap = await databaseRepository.fetchMessages(user);
      final File fileData = File(filePath);
      final String fileName = fileData.path.split('/').last;

      final String uid = chatCollection.doc(snap.docs[0].id).id;
      final String remotePath = 'chats/$uid/$fileType/$fileName';

      final firebaseStorage = FirebaseStorage.instance;

      final storageUploadTask =
          firebaseStorage.ref(remotePath).putFile(fileData);

      await storageUploadTask.whenComplete(() => null);

      final content = await firebaseStorage.ref(remotePath).getDownloadURL();

      chatCollection.doc(snap.docs[0].id).collection('messages').doc().set({
        'type': 'image',
        'content': content,
        'sender': databaseRepository.currentUser!.uid,
        'time': DateTime.now(),
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error Uploading: $e');
    }
  }

  Stream<QuerySnapshot> get chatData => chatCollection
      .where('users', arrayContains: databaseRepository.currentUser!.uid)
      .snapshots();
}
