import 'package:flutter/material.dart'
    show BuildContext, ScaffoldMessenger, SnackBar, Text;

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      duration: const Duration(seconds: 8),
    ),
  );
}
