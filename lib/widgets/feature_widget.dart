import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laathi/utils/constants.dart';

// ignore: must_be_immutable
class FeatureButton extends ConsumerWidget {
  final String name;
  final IconData icon;
  Function? onPressed;

  FeatureButton({
    super.key,
    required this.name,
    this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            if (onPressed != null) {
              onPressed!(context, ref);
            } else {
              // ignore: avoid_print
              print(name);
            }
          },
          // style: ElevatedButton.styleFrom(primary: LGrey),
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(70.0),
                      side: const BorderSide(color: kDarkBlue)))),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(
                  icon,
                  size: 50,
                ),
              ),
              // Text("Location", style: TextStyle(fontSize: 17, color: Colors.white),),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            name,
            style: const TextStyle(fontSize: 20, color: kDarkBlue),
          ),
        ),
      ],
    );
  }
}
