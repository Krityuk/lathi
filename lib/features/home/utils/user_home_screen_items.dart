import 'package:flutter/material.dart';
import 'package:laathi/features/chat/screens/chat_select_screen.dart';
import 'package:laathi/features/home/screens/user_home_screen.dart';

List<Widget> userHomeScreenItems = [
  const Center(child: Text('SOS Page')),
  const UserHomeScreen(),
  const ChatHomeScreen(),
];
