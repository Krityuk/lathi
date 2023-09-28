import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:laathi/utils/constants.dart';

// ignore: must_be_immutable
class CustomIcon extends ConsumerWidget {
  final String iconPath, iconLabel, iconTitle;
  final String? functionRoute;
  final Color iconColor;
  dynamic arguments;
  final Function? onPressed, callback;

  CustomIcon(
      {Key? key,
      this.onPressed,
      this.iconColor = kHeader2,
      required this.iconLabel,
      required this.iconPath,
      required this.iconTitle,
      this.functionRoute,
      this.callback,
      this.arguments})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        if (onPressed != null) {
          onPressed!(context, ref);
        } else if (arguments != null) {
          Navigator.pushNamed(context, functionRoute!, arguments: arguments)
              .then((value) {
            callback;
          });
        } else {
          Navigator.pushNamed(context, functionRoute!).then((value) {
            callback;
          });
        }
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: SvgPicture.asset(
              iconPath,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              semanticsLabel: iconLabel,
              height: 100,
              width: 100,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              iconTitle,
              style: const TextStyle(fontSize: 25),
            ),
          )
        ],
      ),
    );
  }
}
