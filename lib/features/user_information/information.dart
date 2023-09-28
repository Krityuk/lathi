import 'package:flutter/material.dart';

class ProfileInfo extends StatefulWidget {
  final String heading;
  final String entry;
  final String mode;
  final Function toChange;
  const ProfileInfo(
      {Key? key,
      required this.heading,
      required this.entry,
      required this.mode,
      required this.toChange})
      : super(key: key);
  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.heading,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 3.0, left: 8.0, bottom: 20),
              child: Text(
                widget.entry,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
