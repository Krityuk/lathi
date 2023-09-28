import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laathi/features/chat/repository/chat_repository.dart';
import 'package:laathi/features/notification/repository/notification_repository.dart';
import 'package:laathi/utils/constants.dart';

class ConfirmScreen extends ConsumerWidget {
  static const String routeName = '/confirm';
  final String information, userId, userName, type;
  final String location;
  final bool isChat;
  const ConfirmScreen(
      {Key? key,
      required this.information,
      required this.location,
      required this.userId,
      required this.userName,
      required this.type,
      required this.isChat})
      : super(key: key);

  Future<void> showMyDialog(BuildContext context, String alert) async {
    return await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(alert),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                int count = isChat ? 2 : 3;
                Navigator.of(context).popUntil((_) => count-- <= 0);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text(
            "Sending to $userName",
            style: kFontStyle,
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                debugPrint(
                    'k$information information here       😎😎😎😎😎😎😎😎');
                debugPrint('k$location location here       😎😎');
              },
              child: const Text(
                  'print msg to sent'), // Text displayed on the button
            ),
            Text(
              information,
              textAlign: TextAlign.center,
            ),
            Text(
              location,
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      await ref
                          .watch(chatRepositoryProvider)
                          .sendMessage(information, userId)
                          .then((_) async {
                        ref
                            .watch(notificationRepositoryProvider)
                            .addNotification(userId, userName, type);
                        await showMyDialog(context, "Done");
                      });
                    },
                    child: const Text("Send")),
                const SizedBox(
                  width: 15,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
