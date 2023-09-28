import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laathi/features/companion/utils/fetch_contacts.dart';
import 'package:laathi/features/login/repository/login_repository.dart';
import 'package:laathi/features/chat/repository/chat_repository.dart';
import 'package:laathi/features/chat/widgets/chat_user_tile.dart';
import 'package:laathi/features/profile/screens/profile_screen.dart';

class ChatHomeScreen extends ConsumerStatefulWidget {
  const ChatHomeScreen({Key? key}) : super(key: key);
  static const routeName = '/chat-home';

  @override
  ConsumerState<ChatHomeScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatHomeScreen> {
  Stream<QuerySnapshot> getChatData() {
    return ref.watch(chatRepositoryProvider).chatData;
  }

  String getCurrentUserId() {
    return ref.watch(authRepositoryProvider).currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
              ))
        ],
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Chats",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 27),
        ),
      ),
      drawer: const MyDrawer(),
      // List of all chats with their names
      body: StreamBuilder(
          stream: getChatData(),
          builder: (context, snapshot) {
            String currUID = getCurrentUserId();
            return (snapshot.connectionState == ConnectionState.active &&
                    snapshot.hasData)
                ? ListView(
                    children: snapshot.data!.docs.map((chat) {
                    Map<String, dynamic> names = chat['names'];
                    List<dynamic> users = chat['users'];
                    String userId = users[0];
                    if (users[0] == currUID) {
                      userId = users[1];
                    }
                    return Column(
                      children: [
                        ChatTile(
                          chatUserId: userId,
                          chatUserName: names[userId] ?? "Unnamed User",
                        ),
                      ],
                    );
                  }).toList())
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactListScreen(),
                ));
            // ignore: avoid_print
            print('Contact details');
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}
