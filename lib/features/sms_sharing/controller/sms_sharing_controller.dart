import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:laathi/features/sms_sharing/repository/sms_sharing_repository.dart';

//SMS Sharing Controller Provider
final smsSharingControllerProvider = Provider((ref) => SmsSharingController(
    smsSharingRepository: ref.watch(smsSharingRepositoryProvider)));

// Controller for Repository
class SmsSharingController {
  final SmsSharingRepository smsSharingRepository;
  SmsSharingController({required this.smsSharingRepository});
  Future<SmsMessage?> fetchLastSms(BuildContext context) async {
    SmsMessage? smsMessages =
        await smsSharingRepository.fetchLastSms(context);
    return smsMessages;
  }
}
