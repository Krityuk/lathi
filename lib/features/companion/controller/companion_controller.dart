import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laathi/features/companion/Repository/companion_repository.dart';

// Companion Controller Provider
final companionControllerProvider = Provider((ref) => CompanionController(
    companionRepository: ref.watch(companionRepositoryProvider)));

// Controller for Companion Repository
class CompanionController {
  CompanionRepository companionRepository;
  CompanionController({required this.companionRepository});

  Stream<QuerySnapshot> get providersList =>
      companionRepository.providersList;
  Stream<QuerySnapshot> get beneficiariesList =>
      companionRepository.beneficiariesList;
  Future setCompanion(String name, String phoneNumber, BuildContext context) async {
    await companionRepository.setCompanion(name, phoneNumber, context);
  }
}
