import 'package:flutter/material.dart';
import 'package:laathi/utils/constants.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.name,
    required this.contact,
  });

  final String name, contact;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: kOtherColor,
        child: Icon(
          Icons.person,
          color: Colors.white,
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(),
      ),
      subtitle: Text(
        contact,
        style: const TextStyle(),
      ),
    );
  }
}
