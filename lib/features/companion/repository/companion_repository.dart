import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laathi/features/login/controller/login_controller.dart';
import 'package:laathi/repository/app_repository.dart';

//  Provider for companionRepository
final companionRepositoryProvider = Provider(
  (ref) => CompanionRepository(
    appRepository: ref.watch(appRepositoryProvider),
    firebaseFirestore: FirebaseFirestore.instance,
    currentUser: ref.watch(authControllerProvider).currentUser!,
  ),
);

class CompanionRepository {
  final AppRepository appRepository;
  final FirebaseFirestore firebaseFirestore;
  final User currentUser;

  //  consists of all the companions of the current user.
  late CollectionReference providerCollection, beneficiaryCollection;
  CompanionRepository({required this.appRepository,
      required this.firebaseFirestore, required this.currentUser}){
    providerCollection = firebaseFirestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('providers');
    beneficiaryCollection = firebaseFirestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('beneficiaries');
  }
  // companionList getter
  Stream<QuerySnapshot> get providersList => providerCollection.snapshots();
  Stream<QuerySnapshot> get beneficiariesList => beneficiaryCollection.snapshots();
  Future<void> setCompanion(String name, String phoneNumber, BuildContext context) async {
    await appRepository.setCompanion(name, phoneNumber, context);
  }

}
