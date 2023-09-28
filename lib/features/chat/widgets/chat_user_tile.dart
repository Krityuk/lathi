import 'package:flutter/material.dart';
import 'package:laathi/features/chat/screens/chat_companion_screen.dart';

class ChatTile extends StatelessWidget {
  final String chatUserId;
  final String chatUserName;
  const ChatTile(
      {super.key, required this.chatUserId, required this.chatUserName});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ChatScreen.routeName,
            arguments: [chatUserId, chatUserName]);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              chatUserName.substring(0,1),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          title: Text(
            chatUserName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
