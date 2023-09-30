import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/constants.dart';
import '../../chat/repository/chat_repository.dart';
import '../../services/globals/globals.dart';

class ConfirmScreenReqSent extends ConsumerWidget {
  const ConfirmScreenReqSent({super.key});
  static const String routeName = '/confirmReqScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text(
            "Sending to ${Global.beneficiaryName}",
            style: kFontStyle,
          ),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async{
                  await ref
                          .watch(chatRepositoryProvider)
                          .sendMessage("Hey! Send me Your Location", Global.beneficiaryId)
                          .then((_) async {
                        // ref
                        //     .watch(notificationRepositoryProvider)
                        //     .addNotification(userId, userName, type);
                        // await showMyDialog(context, "Done");
                      });
                },
                child: Text('Send Messege to ${Global.beneficiaryName}'),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"))
            ],
          ),
        ),
      ),
    );
  }
}
