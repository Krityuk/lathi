import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laathi/features/notification/models/notification_model.dart';
import 'package:laathi/repository/app_repository.dart';
import 'package:laathi/utils/constants.dart';
import 'package:laathi/utils/show_bar.dart';

class NotificationScreen extends ConsumerWidget {
  // messages[0] indicates the purpose of the list
  // and all the other strings to be sent to the companion.
  static const String routeName = '/notification';
  const NotificationScreen({Key? key}) : super(key: key);
  Widget content(BuildContext context) {
    if (notif.isEmpty) {
      return const Center(
        child: Text(
          'No notifications!',
          style: TextStyle(fontSize: 20.0, color: Colors.blueGrey),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(25.0),
        child: ListView.separated(
            itemCount: notif.length,
            shrinkWrap: true,
            reverse: true,
            itemBuilder: (context, position) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: notif[position],
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) {
              return const Divider();
            }),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    notifNew = false;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kHeader1,
          toolbarHeight: 80.0,
          title: const Text('Notification ',
              style: TextStyle(color: Colors.white)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: StreamBuilder(
            stream: ref
                .watch(appRepositoryProvider)
                .currentUserDocument
                .collection('notifications')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                showSnackBar(
                    context: context, content: snapshot.error.toString());
                return const Text("something is wrong");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              int len = snapshot.data!.docs.length;
              return ListView.builder(
                itemCount: len,
                itemBuilder: (context, index) {
                  QueryDocumentSnapshot querySnap =
                      snapshot.data!.docs[len - index - 1];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        //  TODO: switch-case to the required screen
                      },
                      child: Row(
                        children: [
                          Text(querySnap['name'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.0)),
                          Text(querySnap['type'],
                              style: const TextStyle(fontSize: 20.0)),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ));
  }
}
