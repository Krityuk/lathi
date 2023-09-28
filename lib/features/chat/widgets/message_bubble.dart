import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laathi/utils/show_bar.dart';
import 'package:laathi/features/chat/repository/chat_repository.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';

class Messages extends ConsumerStatefulWidget {
  //Uid and Uname of the user in the current chat
  final String uid, uname;
  const Messages({super.key, required this.uid, required this.uname});
  @override
  ConsumerState<Messages> createState() => _MessagesState();
}

// ignore: camel_case_types
class _MessagesState extends ConsumerState<Messages> {
  final player = AudioPlayer();

  Widget messages(String text, String uid, String sender, String type) {
    if (text.contains('.m4a') ||
      text.contains('.mp3') ||
      text.contains('.aac')) {
      type = 'audio';
    }

    if (type == 'image'){
      return Image.network(
          text,
          height: 250);
    } else if (type == 'audio') {
      return TextButton(
          child: const Text('Play'),
          onPressed: () {
            player.play(UrlSource(text));
          });
    } else if (type == 'video') {
      return TextButton(
          child: const Text('Play'),
          onPressed: () {
            player.play(UrlSource(text));
          });
    } else if (type == 'document'){
      // Need to edit the following as it is repeated for the type 'text'
      return Linkify(
        text: text
      );
    } else {
      return Linkify(
        text: text,
        linkStyle: const TextStyle(
          color: Colors.blueGrey,
        ),
        style: TextStyle(
            color: uid != sender ? Colors.white : Colors.black54, fontSize: 15),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    final String uid = widget.uid;
    return FutureBuilder(
      future: ref.watch(chatRepositoryProvider).getChatMessagesStream(uid),
      builder: (context, snap) => (snap.hasData)
          ? StreamBuilder(
              stream: snap.data,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  reverse: true,
                  itemBuilder: (_, index) {
                    QueryDocumentSnapshot querySnap =
                        snapshot.data!.docs[len - index - 1];
                    Timestamp t = querySnap['time'];
                    // ignore: unused_local_variable
                    DateTime d = t.toDate();
                    return Padding(
                      padding: EdgeInsets.only(
                          top: 8.0,
                          bottom: 8.0,
                          right: (uid != querySnap['sender'] ? 0.0 : 50.0),
                          left: (uid != querySnap['sender'] ? 50.0 : 0.0)),
                      child: Column(
                        crossAxisAlignment: uid != querySnap['sender']
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Text(
                              uid != querySnap['sender'] ? 'You' : widget.uname,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            ),
                          ),
                          Material(
                            borderRadius: BorderRadius.only(
                                topLeft: uid != querySnap['sender']
                                    ? const Radius.circular(30)
                                    : const Radius.circular(0),
                                topRight: uid != querySnap['sender']
                                    ? const Radius.circular(0)
                                    : const Radius.circular(30),
                                bottomLeft: const Radius.circular(30),
                                bottomRight: const Radius.circular(30)),
                            elevation: 5,
                            color: uid != querySnap['sender']
                                ? Colors.lightBlueAccent
                                : Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: messages(
                                  querySnap['content'], uid, querySnap['sender'],querySnap['type']),
                            ),
                          ),
                        ],
                      ),
                    );
                    // return Padding(
                    //   padding: const EdgeInsets.only(top: 8, bottom: 8),
                    //   child: Column(
                    //     crossAxisAlignment: uid != querySnap['sender']
                    //         ? CrossAxisAlignment.end
                    //         : CrossAxisAlignment.start,
                    //     children: [
                    //       SizedBox(
                    //         width: MediaQuery.of(context).size.width*0.7,
                    //         child: ListTile(
                    //           shape: RoundedRectangleBorder(
                    //             side: const BorderSide(
                    //               color: Colors.purple,
                    //             ),
                    //             borderRadius: BorderRadius.circular(10),
                    //           ),
                    //           title: Padding(
                    //             padding: const EdgeInsets.only(bottom: 8.0),
                    //             child: Text(uid != querySnap['sender'] ? 'You' : widget.uname,
                    //               style: const TextStyle(
                    //                   fontSize: 15, color: Colors.black54),
                    //             ),
                    //           ),
                    //           subtitle: Row(
                    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               SizedBox(
                    //                 width: MediaQuery.of(context).size.width*0.3,
                    //                 child: Text(
                    //                   querySnap['body'],
                    //                   softWrap: true,
                    //                   style: const TextStyle(
                    //                     color: Colors.black,
                    //                     fontSize: 15,
                    //                   ),
                    //                 ),
                    //               ),
                    //               Text(
                    //                 "${d.hour}:${d.minute}",
                    //               )
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // );
                  },
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(color: Colors.red),
            ),
    );
  }
}
