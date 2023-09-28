import 'package:flutter/material.dart';

//Constant Color Values
const Color kScaffoldColor = Color(0xFFF3F4F8);
const Color kOtherColor = Color(0xFF59C1BD);
const Color kPrimaryColor = Color(0xFF399DB8);
const Color kSecondaryColor = Color(0xFFF95C54);
const Color kErrorBorderColor = Color(0xFFE74C3C);
const Color kTextLightColor = Color(0xFFC5BDCD);
const Color kTextColor = Color.fromARGB(255, 52, 44, 57);
const Color kDarkBlue = Color(0xff050A30);
const Color kGrey = Color(0xff4D4C4C);
const Color kLightGrey = Color(0xffB9C2C4);

const Color kHeader2 = Color(0xFF00B4D8);
const Color kHeader1 = Color(0xFF0096C7);

const Color k1 = Color(0x00203FFF);
const Color k2 = Color(0xADEFD1FF);

//Constant Text Style
const TextStyle kFontStyle =
    TextStyle(color: kDarkBlue, fontSize: 25, fontWeight: FontWeight.w600);

loadingDialogBox(BuildContext context, String loadingMessage) {
  AlertDialog alertBox = AlertDialog(
    content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const CircularProgressIndicator(
            color: kHeader1,
          ),
          const SizedBox(
            width: 30,
          ),
          Text(
            loadingMessage,
            style: const TextStyle(
              color: Colors.black,
            ),
          )
        ]),
  );

  showDialog(
      barrierDismissible: false,
      // barrierDismissible parameter to control whether the dialog can be dismissed by tapping outside of it. Setting barrierDismissible to false means that the user cannot dismiss the dialog in this manner.
      context: context,
      // The context parameter refers to the current BuildContext in which the dialog should be displayed.
      builder: (BuildContext context) {
        return alertBox;
      });
}
