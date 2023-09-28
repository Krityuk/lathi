import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:laathi/features/medicine_reminder/screens/medicine_home_screen.dart';
import 'package:laathi/features/services/utils/send_message.dart';
import 'package:laathi/features/sms_sharing/controller/sms_sharing_controller.dart';
import 'package:laathi/utils/constants.dart';
import 'package:laathi/widgets/icon_widget.dart';

class ServicesScreen extends ConsumerWidget {
  static const String routeName = '/services';
  const ServicesScreen({super.key});
  Future<List<String>> fetchMessages(
      WidgetRef ref, BuildContext context) async {
    SmsMessage? smsMessages =
        await ref.watch(smsSharingControllerProvider).fetchLastSms(context);
    List<String> infoList = ['sms'];
    infoList.add((smsMessages != null) ? smsMessages.sender! : "No Sender");
    infoList.add((smsMessages != null) ? smsMessages.body! : "No Message");

    return infoList;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services',
            style: TextStyle(color: Colors.white, fontSize: 30)),
        backgroundColor: kHeader1,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 25.0,
            mainAxisSpacing: 25.0,
            children: [
              CustomIcon(
                iconLabel: 'Location',
                iconPath: 'assets/icons/location.svg',
                iconTitle: 'Location',
                functionRoute: SendMessage.routeName,
                //  argument set as a list of string with the zeroth index having
                //  'location' as the value to indicate the location sharing operation
                arguments: const [
                  ['location'],
                  false
                ],
              ),
              FutureBuilder(
                future: fetchMessages(ref, context),
                builder: (context, snapshot) => CustomIcon(
                  iconLabel: 'OTP',
                  iconPath: 'assets/icons/otp.svg',
                  iconTitle: 'OTP',
                  functionRoute: SendMessage.routeName,
                  arguments: [snapshot.data, false],
                ),
              ),
              CustomIcon(
                iconLabel: 'Medicines',
                iconPath: 'assets/icons/medicine.svg',
                iconTitle: 'Medicines',
                functionRoute: MedicineLandingScreen.routeName,
              ),
              CustomIcon(
                iconLabel: 'Document',
                iconPath: 'assets/icons/document.svg',
                iconTitle: 'Document',
                functionRoute: 'VoiceRecorder.routeName',
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: MobileScreenLayout(),
    );
  }
}
