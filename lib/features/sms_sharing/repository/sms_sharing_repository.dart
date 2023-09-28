import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laathi/utils/show_bar.dart';

//  OTP Sharing Repository Provider
final smsSharingRepositoryProvider = Provider((ref) => SmsSharingRepository());

class SmsSharingRepository {
  SmsQuery query = SmsQuery();
  //  function to fetch SMS messages
  Future<SmsMessage?> fetchLastSms(BuildContext context) async {
    List<SmsMessage> messages = [];
    //  Messages cannot be retrieved without sms permission
    var status = await Permission.sms.status;
    if (status.isDenied) {
      await Permission.sms.request();
    }
    if (status.isGranted) {
      //Using flutter_sms_inbox package to fetch sms from phone
      messages = await query.querySms(
          count: 1, kinds: [SmsQueryKind.inbox]).onError((error, stackTrace) {
        showSnackBar(context: context, content: error.toString());
        return [];
      });
    }
    return messages.isNotEmpty ? messages[0] : null;
  }
  Future<List<String>> fetchMessages(
      WidgetRef ref, BuildContext context) async {
    SmsMessage? smsMessages =
    await fetchLastSms(context);
    List<String> infoList = ['otp messages'];
    infoList.add((smsMessages != null) ? smsMessages.sender! : "No Sender");
    infoList.add((smsMessages != null) ? smsMessages.body! : "No Message");

    return infoList;
  }
}
